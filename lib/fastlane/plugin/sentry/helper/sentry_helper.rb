module Fastlane
  module Helper
    class SentryHelper
      def self.check_sentry_cli!
        if !`which sentry-cli`.include?('sentry-cli')
          UI.error("You have to install sentry-cli version #{Fastlane::Sentry::CLI_VERSION} to use this plugin")
          UI.error("")
          UI.error("Install it using:")
          UI.command("brew install getsentry/tools/sentry-cli")
          UI.error("OR")
          UI.command("curl -sL https://sentry.io/get-cli/ | bash")
          UI.error("If you don't have homebrew, visit http://brew.sh")
          UI.user_error!("Install sentry-cli and start your lane again!")
        end

        sentry_cli_version = Gem::Version.new(`sentry-cli --version`.scan(/(?:\d+\.?){3}/).first)
        required_version = Gem::Version.new(Fastlane::Sentry::CLI_VERSION)
        if sentry_cli_version < required_version
          UI.user_error!("Your sentry-cli is outdated, please upgrade to at least version #{Fastlane::Sentry::CLI_VERSION} and start your lane again!")
        end
      end
    end
  end
end
