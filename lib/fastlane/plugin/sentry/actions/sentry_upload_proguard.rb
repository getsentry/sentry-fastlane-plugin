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

        command.push('--no-upload') if params[:no_upload]
        command.push('--write-properties').push(params[:write_properties]) unless params[:write_properties].nil?
        command.push('--require-one') if params[:require_one]
        command.push('--uuid').push(params[:uuid]) unless params[:uuid].nil?

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
                                                     end),
          FastlaneCore::ConfigItem.new(key: :no_upload,
                                       description: "Disable the actual upload. This runs all steps for the processing \
                                       but does not trigger the upload. This is useful if you just want to verify the \
                                       mapping files and write the proguard UUIDs into a properties file",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :write_properties,
                                       description: "Write the UUIDs for the processed mapping files into the given \
                                       properties file",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :require_one,
                                       description: "Requires at least one file to upload or the command will error",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :uuid,
                                       description: "Explicitly override the UUID of the mapping file with another one. \
                                       This should be used with caution as it means that you can upload multiple mapping \
                                       files if you don't take care. This however can be useful if you have a build \
                                       process in which you need to know the UUID of the proguard file before it was \
                                       created. If you upload a file with a forced UUID you can only upload a single \
                                       proguard file",
                                       optional: true)
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
