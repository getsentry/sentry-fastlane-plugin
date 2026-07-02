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
          "snapshots",
          "upload",
          "--app-id",
          app_id
        ]

        if params[:diff_threshold]
          command += ["--diff-threshold", params[:diff_threshold].to_s]
        end

        command << path

        Helper::SentryConfig.build_vcs_command(command, params)

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
        "This action allows you to upload snapshot images to Sentry to check for visual regressions. NOTE: This features is experimental and might be changed in future releases."
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
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :diff_threshold,
                                       description: "Only report images as changed if their difference percentage exceeds this value (0.0–1.0). " \
                                                    "For example, 0.001 ignores changes affecting less than 0.1% of pixels. " \
                                                    "Useful for filtering out sub-pixel rendering noise (e.g. anti-aliasing, transparency). " \
                                                    "Defaults to 0.0 (any pixel change is reported) when not set",
                                       optional: true,
                                       type: Float,
                                       verify_block: proc do |value|
                                                       UI.user_error! "diff_threshold must be between 0.0 and 1.0" unless value >= 0.0 && value <= 1.0
                                                     end)
        ] + Helper::SentryConfig.common_vcs_config_items
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
