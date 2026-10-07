require 'open3'
require 'shellwords'

module Fastlane
  module Helper
    class SentryHelper
      VERSION_PATTERN = /\A\d+\.\d+\.\d+/
      MIGRATION_GUIDE_URL = 'https://github.com/getsentry/sentry-fastlane-plugin/blob/master/MIGRATION.md'.freeze

      # Resolves the Sentry CLI executable to use and verifies that it is compatible with this plugin.
      #
      # Uses `sentry_cli_path` (or the SENTRY_CLI_PATH environment variable) when provided, otherwise the
      # pinned CLI version managed by the plugin (see SentryCliInstaller).
      def self.find_and_check_sentry_cli_path!(params)
        required_version = Gem::Version.new(SentryCliInstaller.version)

        sentry_cli_path = params[:sentry_cli_path]
        sentry_cli_path = SentryCliInstaller.ensure_installed! if sentry_cli_path.to_s.empty?

        version_output = `#{Shellwords.escape(sentry_cli_path)} --version`.to_s
        if version_output.include?('sentry-cli')
          UI.user_error!("'#{sentry_cli_path}' is the legacy sentry-cli, which is no longer supported by this plugin. " \
                         "Install the new Sentry CLI (https://github.com/getsentry/cli) or remove `sentry_cli_path` to use the version managed by the plugin. " \
                         "See #{MIGRATION_GUIDE_URL}")
        end

        # Match anchored tokens rather than scanning the whole output to avoid polynomial regex backtracking.
        version_string = version_output.split.filter_map { |token| token[VERSION_PATTERN] }.first
        UI.user_error!("Could not determine the version of the Sentry CLI at '#{sentry_cli_path}'") if version_string.nil?

        sentry_cli_version = Gem::Version.new(version_string)
        if sentry_cli_version < required_version
          UI.user_error!("Your Sentry CLI is outdated, please upgrade to at least version #{required_version} and start your lane again!")
        end

        UI.success("Using Sentry CLI #{sentry_cli_version}")
        sentry_cli_path
      end

      def self.call_sentry_cli(params, sub_command)
        sentry_path = self.find_and_check_sentry_cli_path!(params)
        command = [sentry_path] + sub_command
        UI.message "Starting Sentry CLI..."

        final_command = command.map { |arg| Shellwords.escape(arg) }.join(" ")

        if FastlaneCore::Globals.verbose?
          UI.command(final_command)
        end

        env = {
          'SENTRY_PIPELINE' => "sentry-fastlane-plugin/#{Fastlane::Sentry::VERSION}",
          # The plugin pins the CLI version, so the CLI's own update check is just noise.
          'SENTRY_CLI_NO_UPDATE_CHECK' => ENV.fetch('SENTRY_CLI_NO_UPDATE_CHECK', '1')
        }
        Open3.popen3(env, final_command) do |stdin, stdout, stderr, status_thread|
          out_reader = Thread.new do
            output = []

            stdout.each_line do |line|
              l = line.strip!
              UI.message(l)
              output << l
            end

            output.join
          end

          err_reader = Thread.new do
            stderr.each_line do |line|
              UI.message(line.strip!)
            end
          end

          unless status_thread.value.success?
            UI.user_error!('Error while calling Sentry CLI')
          end

          err_reader.join
          out_reader.value
        end
      end
    end
  end
end
