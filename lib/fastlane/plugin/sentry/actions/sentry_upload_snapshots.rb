module Fastlane
  module Actions
    class SentryUploadSnapshotsAction < Action
      def self.run(params)
        Helper::SentryConfig.parse_api_params(params)

        path = params[:path]
        app_id = params[:app_id]

        UI.user_error!("Path does not exist: #{path}") unless File.exist?(path)
        UI.user_error!("Path is not a directory: #{path}") unless File.directory?(path)

        command = [
          "build",
          "snapshots",
          "--app-id",
          app_id,
          path
        ]

        Helper::SentryHelper.call_sentry_cli(params, command)
        UI.success("Successfully uploaded snapshots!")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload snapshot images to Sentry (EXPERIMENTAL)"
      end

      def self.details
        "This action allows you to upload snapshot images to Sentry to check for visual regressions."
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :path,
                                       description: "Path to the folder containing snapshot images",
                                       optional: false,
                                       verify_block: proc do |value|
                                                       UI.user_error! "Could not find path '#{value}'" unless File.exist?(value)
                                                       UI.user_error! "Path is not a directory: '#{value}'" unless File.directory?(value)
                                                     end),
          FastlaneCore::ConfigItem.new(key: :app_id,
                                       description: "Application identifier",
                                       optional: false)
        ]
      end

      def self.return_value
        nil
      end

      def self.authors
        ["sentry"]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
