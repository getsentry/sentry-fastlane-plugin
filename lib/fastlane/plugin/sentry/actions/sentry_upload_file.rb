module Fastlane
  module Actions
    class SentryUploadFileAction < Action
      def self.run(params)
        require 'shellwords'

        Helper::SentryHelper.check_sentry_cli!
        Helper::SentryConfig.parse_api_params(params)

        version = params[:version]
        file = params[:file]
        file_url_arg = params[:file_url] ? "'#{params[:file_url]}'" : ''

        command = "sentry-cli releases files '#{Shellwords.escape(version)}' upload #{file} #{file_url_arg}"

        Helper::SentryHelper.call_sentry_cli(command)
        UI.success("Successfully uploaded files to release: #{version}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload files to a release of a project on Sentry"
      end

      def self.details
        [
          "This action allows you to upload files to a release of a project on Sentry.",
          "See https://docs.sentry.io/learn/cli/releases/#upload-files for more information."
        ].join(" ")
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: "Release version on Sentry"),
          FastlaneCore::ConfigItem.new(key: :file,
                                       description: "Path to the file to upload",
                                       verify_block: proc do |value|
                                         UI.user_error! "Could not find file at path '#{value}'" unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :file_url,
                                       description: "Optional URL we should associate with the file",
                                       optional: true)
        ]
      end

      def self.return_value
        nil
      end

      def self.authors
        ["wschurman"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
