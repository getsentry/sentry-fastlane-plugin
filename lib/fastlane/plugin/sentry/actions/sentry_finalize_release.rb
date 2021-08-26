module Fastlane
  module Actions
    class SentryFinalizeReleaseAction < Action
      def self.run(params)
        require 'shellwords'

        Helper::SentryHelper.check_sentry_cli(params[:sentry_cli_path])
        Helper::SentryConfig.parse_api_params(params)

        version = params[:version]
        version = "#{params[:app_identifier]}@#{params[:version]}" if params[:app_identifier]
        version = "#{version}+#{params[:build]}" if params[:build]

        sentry_cli = "sentry-cli"
        unless params[:sentry_cli_path].nil?
            sentry_cli = params[:sentry_cli_path]
        end
        command = [
          sentry_cli,
          "releases",
          "finalize",
          version
        ]

        Helper::SentryHelper.call_sentry_cli(command)
        UI.success("Successfully finalized release: #{version}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Finalize a release for a project on Sentry"
      end

      def self.details
        [
          "This action allows you to finalize releases created for a project on Sentry.",
          "See https://docs.sentry.io/learn/cli/releases/#finalizing-releases for more information."
        ].join(" ")
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: "Release version to finalize on Sentry"),
          FastlaneCore::ConfigItem.new(key: :app_identifier,
                                      short_option: "-a",
                                      env_name: "SENTRY_APP_IDENTIFIER",
                                      description: "App Bundle Identifier, prepended to version",
                                      optional: true),
          FastlaneCore::ConfigItem.new(key: :sentry_cli_path,
                                     env_name: "SENTRY_CLI_PATH",
                                      description: "Path to your sentry-cli. Default to `which sentry-cli`",
                                      optional: true,
                                      verify_block: proc do |value|
                                        UI.user_error! "Could not find sentry-cli." unless File.exist?(File.expand_path(value))
                                      end),
          FastlaneCore::ConfigItem.new(key: :build,
                                      short_option: "-b",
                                      description: "Release build to finalize on Sentry",
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
