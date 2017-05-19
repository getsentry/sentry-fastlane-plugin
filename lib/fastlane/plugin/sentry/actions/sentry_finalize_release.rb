module Fastlane
  module Actions
    class SentryFinalizeReleaseAction < Action
      def self.run(params)
        require 'shellwords'

        Helper::SentryHelper.check_sentry_cli!
        Helper::SentryConfig.parse_api_params(params)

        version = params[:version]

        command = [
          "sentry-cli",
          "releases",
          "finalize",
          Shellwords.escape(version)
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
                                       description: "Release version to finalize on Sentry")
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
