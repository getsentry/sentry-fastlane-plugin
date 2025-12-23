module Fastlane
  module Actions
    class SentryUploadProguardAction < Action
      def self.run(params)
        Helper::SentryConfig.parse_api_params(params)

        mapping_path = params[:mapping_path]

        # Verify file exists
        UI.user_error!("Mapping file does not exist at path: #{mapping_path}") unless File.exist? mapping_path

        command = [
          "upload-proguard",
          mapping_path
        ]

        Helper::SentryHelper.call_sentry_cli(params, command)
        UI.success("Successfully uploaded mapping file!")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload mapping to a project on Sentry"
      end

      def self.details
        [
          "This action allows you to upload the proguard mapping file to Sentry.",
          "See https://docs.sentry.io/product/cli/dif/#proguard-mapping-upload for more information."
        ].join(" ")
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :mapping_path,
                                       env_name: "ANDROID_MAPPING_PATH",
                                       description: "Path to your proguard mapping.txt file",
                                       optional: false,
                                       verify_block: proc do |value|
                                                       UI.user_error! "Could not find your mapping file at path '#{value}'" unless File.exist?(value)
                                                     end)
        ]
      end

      def self.return_value
        nil
      end

      def self.authors
        ["mpp-anasa"]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
