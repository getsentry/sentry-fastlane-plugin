module Fastlane
  module Actions
    class SentryUploadDsymAction < Action
      def self.run(params)
        check_sentry_cli!

        # Params - API
        url = params[:url]
        auth_token = params[:auth_token]
        api_key = params[:api_key]
        org = params[:org_slug]
        project = params[:project_slug]

        # Params - dSYM
        dsym_path = params[:dsym_path]
        dsym_paths = params[:dsym_paths] || []

        has_api_key = !api_key.to_s.empty?
        has_auth_token = !auth_token.to_s.empty?

        # Will fail if none or both authentication methods are provided
        if !has_api_key && !has_auth_token
          UI.user_error!("No API key or authentication token found for SentryAction given, pass using `api_key: 'key'` or `auth_token: 'token'`")
        elsif has_api_key && has_auth_token
          UI.user_error!("Both API key and authentication token found for SentryAction given, please only give one")
        elsif has_api_key && !has_auth_token
          UI.deprecated("Please consider switching to auth_token ... api_key will be removed in the future")
        end

        ENV['SENTRY_API_KEY'] = api_key unless api_key.to_s.empty?
        ENV['SENTRY_AUTH_TOKEN'] = auth_token unless auth_token.to_s.empty?
        ENV['SENTRY_URL'] = url unless url.to_s.empty?
        ENV['SENTRY_LOG_LEVEL'] = 'info' if $verbose

        # Verify dsym(s)
        dsym_paths += [dsym_path] unless dsym_path.nil?
        dsym_paths = dsym_paths.map { |path| File.absolute_path(path) }
        dsym_paths.each do |path|
          UI.user_error!("dSYM does not exist at path: #{path}") unless File.exists? path
        end

        UI.success("sentry-cli #{Fastlane::Sentry::CLI_VERSION} installed!")
        call_sentry_cli(dsym_paths, org, project)
        UI.success("Successfully uploaded dSYMs!")
      end

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

        sentry_cli_version = `sentry-cli --version`.gsub(/[^\d]/, '').to_i
        required_version = Fastlane::Sentry::CLI_VERSION.gsub(/[^\d]/, '').to_i
        if sentry_cli_version < required_version
          UI.user_error!("Your sentry-cli is outdated, please upgrade to at least version #{Fastlane::Sentry::CLI_VERSION} and start your lane again!")
        end
      end

      def self.call_sentry_cli(dsym_paths, org, project)
        UI.message "Starting sentry-cli..."
        require 'open3'
        require 'shellwords'
        org = Shellwords.escape(org)
        project = Shellwords.escape(project)
        error = []
        Open3.popen3("sentry-cli upload-dsym '#{dsym_paths.join("','")}' --org #{org} --project #{project}") do |stdin, stdout, stderr, wait_thr|
          while line = stderr.gets do
            error << line.strip!
          end
          while line = stdout.gets do
            UI.message(line.strip!)
          end
          exit_status = wait_thr.value
          unless exit_status.success? && error.empty?
            handle_error(error)
          end
        end
      end

      def self.handle_error(errors)
        fatal = false
        for error in errors do
          if error
            if error.include?('[INFO]')
              UI.verbose("#{error}")
            else
              UI.error("#{error}")
              fatal = true
            end
          end
        end
        UI.user_error!('Error while trying to upload dSYM to Sentry') unless !fatal
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload dSYM symbolication files to Sentry"
      end

      def self.details
        [
          "This action allows you to upload symbolication files to Sentry.",
          "It's extra useful if you use it to download the latest dSYM files from Apple when you",
          "use Bitcode"
        ].join(" ")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: "SENTRY_URL",
                                       description: "Url for Sentry",
                                       is_string: true,
                                       default_value: "https://app.getsentry.com/api/0",
                                       optional: true
                                      ),
          FastlaneCore::ConfigItem.new(key: :auth_token,
                                       env_name: "SENTRY_AUTH_TOKEN",
                                       description: "Authentication token for Sentry",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       env_name: "SENTRY_API_KEY",
                                       description: "API key for Sentry",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :org_slug,
                                       env_name: "SENTRY_ORG_SLUG",
                                       description: "Organization slug for Sentry project",
                                       verify_block: proc do |value|
                                         UI.user_error!("No organization slug for SentryAction given, pass using `org_slug: 'org'`") unless value and !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :project_slug,
                                       env_name: "SENTRY_PROJECT_SLUG",
                                       description: "Project slug for Sentry",
                                       verify_block: proc do |value|
                                         UI.user_error!("No project slug for SentryAction given, pass using `project_slug: 'project'`") unless value and !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :dsym_path,
                                       env_name: "SENTRY_DSYM_PATH",
                                       description: "Path to your symbols file. For iOS and Mac provide path to app.dSYM.zip",
                                       default_value: Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH],
                                       optional: true,
                                       verify_block: proc do |value|
                                         # validation is done in the action
                                       end),
          FastlaneCore::ConfigItem.new(key: :dsym_paths,
                                       env_name: "SENTRY_DSYM_PATHS",
                                       description: "Path to an array of your symbols file. For iOS and Mac provide path to app.dSYM.zip",
                                       default_value: Actions.lane_context[SharedValues::DSYM_PATHS],
                                       is_string: false,
                                       optional: true,
                                       verify_block: proc do |value|
                                         # validation is done in the action
                                       end)

        ]
      end

      def self.return_value
        nil
      end

      def self.authors
        ["joshdholtz"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
