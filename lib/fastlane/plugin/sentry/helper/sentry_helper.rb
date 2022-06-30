module Fastlane
  module Helper
    class SentryHelper
      def self.find_and_check_sentry_cli_path!(params)
        sentry_path = params[:sentry_cli_path] || FastlaneCore::CommandExecutor.which('sentry-cli')
        if sentry_path.nil?
          UI.error("You have to install sentry-cli version #{Fastlane::Sentry::CLI_VERSION} to use this plugin")
          UI.error("")
          UI.error("Install it using:")
          UI.command("brew install getsentry/tools/sentry-cli")
          UI.error("OR")
          UI.command("curl -sL https://sentry.io/get-cli/ | bash")
          UI.error("If you don't have homebrew, visit http://brew.sh")
          UI.user_error!("Install sentry-cli and start your lane again!")
        end

        sentry_cli_version = Gem::Version.new(`#{sentry_path} --version`.scan(/(?:\d+\.?){3}/).first)

        required_version = Gem::Version.new(Fastlane::Sentry::CLI_VERSION)
        if sentry_cli_version < required_version
          UI.user_error!("Your sentry-cli is outdated, please upgrade to at least version #{Fastlane::Sentry::CLI_VERSION} and start your lane again!")
        end

        UI.success("sentry-cli #{sentry_cli_version} installed!")
        sentry_path
      end

      def self.call_sentry_cli(params, sub_command)
        sentry_path = self.find_and_check_sentry_cli_path!(params)
        command = [sentry_path] + sub_command
        UI.message "Starting sentry-cli..."
        require 'open3'

        final_command = command.map { |arg| Shellwords.escape(arg) }.join(" ")

        if FastlaneCore::Globals.verbose?
          UI.command(final_command)
        end

        Open3.popen2e(final_command) do |stdin, stdout_and_stderr, status_thread|
          stdout_and_stderr.each_line do |line|
            UI.message(line.strip!)
          end

          unless status_thread.value.success?
            UI.user_error!('Error while calling Sentry CLI')
          end
        end
      end
    end
  end
end
