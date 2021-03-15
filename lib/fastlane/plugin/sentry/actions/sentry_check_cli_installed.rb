module Fastlane
  module Actions
    class SentryCheckCliInstalledAction < Action
      def self.run(params)
        Helper::SentryHelper.check_sentry_cli!
        UI.success("Successfully checked that sentry-cli is installed")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Checks that sentry-cli with the correct version is installed"
      end

      def self.details
        [
          "This action checks that the senty-cli is installed and meets the mimum verson requirements.",
          "You can use it at the start of your lane to ensure that sentry-cli is correctly installed."
        ].join(" ")
      end

      def self.return_value
        nil
      end

      def self.authors
        ["matt-oakes"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
