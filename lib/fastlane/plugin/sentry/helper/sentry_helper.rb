module Fastlane
  module Helper
    class SentryHelper
      def self.find_and_check_sentry_cli_path!(params)
        bundled_sentry_cli_path = `bundle exec sentry_cli_path`
        bundled_sentry_cli_version = Gem::Version.new(`#{bundled_sentry_cli_path} --version`.scan(/(?:\d+\.?){3}/).first)

        sentry_cli_path = params[:sentry_cli_path] || bundled_sentry_cli_path

        sentry_cli_version = Gem::Version.new(`#{sentry_cli_path} --version`.scan(/(?:\d+\.?){3}/).first)

        if sentry_cli_version < bundled_sentry_cli_version
          UI.user_error!("Your sentry-cli is outdated, please upgrade to at least version #{bundled_sentry_cli_version} and start your lane again!")
        end

        UI.success("Using sentry-cli #{sentry_cli_version}")
        sentry_cli_path
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
          # While most of the commands are just a pass-through for stdout/stderr
          # we do rely on parsing stdout in `fallback_sentry_cli_auth` helper
          # We can ignore `stderr`, which is responsible for logging
          # as `sentry-cli info --config-status-json` which we use, doesnt allow `--verbose`.
          output = []

          stdout_and_stderr.each_line do |line|
            l = line.strip!
            UI.message(l)
            output << l
          end

          unless status_thread.value.success?
            UI.user_error!('Error while calling Sentry CLI')
          end

          output.join
        end
      end
    end
  end
end
