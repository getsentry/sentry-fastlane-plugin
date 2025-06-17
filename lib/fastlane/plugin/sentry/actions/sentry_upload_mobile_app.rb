module Fastlane
  module Actions
    class SentryUploadMobileAppAction < Action
      def self.run(params)
        Helper::SentryConfig.parse_api_params(params)

        # Verify xcarchive path
        xcarchive_path = params[:xcarchive_path]
        UI.user_error!("Could not find xcarchive at path '#{xcarchive_path}'") unless File.exist?(xcarchive_path)
        UI.user_error!("Path '#{xcarchive_path}' is not an xcarchive") unless File.extname(xcarchive_path) == '.xcarchive'

        command = [
          "mobile-app",
          "upload",
          File.absolute_path(xcarchive_path)
        ]

        Helper::SentryHelper.call_sentry_cli(params, command)
        UI.success("Successfully uploaded mobile app archive: #{xcarchive_path}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload iOS app archive to Sentry"
      end

      def self.details
        "This action allows you to upload iOS app archives (.xcarchive) to Sentry."
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :xcarchive_path,
                                       description: "Path to your iOS app archive (.xcarchive)",
                                       default_value: Actions.lane_context[SharedValues::XCODEBUILD_ARCHIVE],
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find xcarchive at path '#{value}'") unless File.exist?(value)
                                         UI.user_error!("Path '#{value}' is not an xcarchive") unless File.extname(value) == '.xcarchive'
                                       end)
        ]
      end

      def self.return_value
        nil
      end

      def self.authors
        ["runningcode"]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
