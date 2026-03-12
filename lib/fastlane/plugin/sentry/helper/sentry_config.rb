module Fastlane
  module Helper
    class SentryConfig
      def self.common_cli_config_items
        [
          FastlaneCore::ConfigItem.new(key: :sentry_cli_path,
                                       env_name: "SENTRY_CLI_PATH",
                                       description: "Path to your sentry-cli. Defaults to `which sentry-cli`",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error! "'#{value}' is not executable" unless FastlaneCore::Helper.executable?(value)
                                       end)
        ]
      end

      def self.common_api_config_items
        [
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: "SENTRY_URL",
                                       description: "Url for Sentry",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :auth_token,
                                       env_name: "SENTRY_AUTH_TOKEN",
                                       description: "Authentication token for Sentry",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :org_slug,
                                       env_name: "SENTRY_ORG_SLUG",
                                       description: "Organization slug for Sentry project",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :project_slug,
                                       env_name: "SENTRY_PROJECT_SLUG",
                                       description: "Project slug for Sentry",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :log_level,
                                       env_name: "SENTRY_LOG_LEVEL",
                                       description: "Configures the log level used by sentry-cli",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error! "Invalid log level '#{value}'" unless ['trace', 'debug', 'info', 'warn', 'error'].include? value.downcase
                                       end)
        ] + self.common_cli_config_items
      end

      def self.parse_api_params(params)
        require 'shellwords'

        url = params[:url]
        auth_token = params[:auth_token]
        org = params[:org_slug]
        project = params[:project_slug]
        log_level = params[:log_level]

        has_org = !org.to_s.empty?
        has_project = !project.to_s.empty?
        has_auth_token = !auth_token.to_s.empty?

        ENV['SENTRY_URL'] = url unless url.to_s.empty?

        if log_level.to_s.empty?
          ENV['SENTRY_LOG_LEVEL'] = 'debug' if FastlaneCore::Globals.verbose?
        else
          ENV['SENTRY_LOG_LEVEL'] = log_level
        end

        # Fallback to .sentryclirc if possible when no auth token is provided
        if !has_auth_token && fallback_sentry_cli_auth(params)
          UI.important("No auth config provided, will fallback to .sentryclirc")
        else
          # Will fail if no authentication token is provided
          unless has_auth_token
            UI.user_error!("No authentication token found for SentryAction given, pass using `auth_token: 'token'`")
          end
          ENV['SENTRY_AUTH_TOKEN'] = auth_token unless auth_token.to_s.empty?
        end

        if has_org && has_project
          ENV['SENTRY_ORG'] = Shellwords.escape(org) unless org.to_s.empty?
          ENV['SENTRY_PROJECT'] = Shellwords.escape(project) unless project.to_s.empty?
        elsif !has_org
          UI.important("Missing 'org_slug' parameter. Provide both 'org_slug' and 'project_slug'. Falling back to .sentryclirc")
        elsif !has_project
          UI.important("Missing 'project_slug' parameter. Provide both 'org_slug' and 'project_slug'. Falling back to .sentryclirc")
        end
      end

      def self.common_vcs_config_items
        [
          FastlaneCore::ConfigItem.new(key: :head_sha,
                                       env_name: "SENTRY_HEAD_SHA",
                                       description: "The SHA of the head of the current branch",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :base_sha,
                                       env_name: "SENTRY_BASE_SHA",
                                       description: "The SHA of the base branch",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :vcs_provider,
                                       env_name: "SENTRY_VCS_PROVIDER",
                                       description: "The version control system provider (e.g., 'github', 'gitlab')",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :head_repo_name,
                                       env_name: "SENTRY_HEAD_REPO_NAME",
                                       description: "The name of the head repository",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :base_repo_name,
                                       env_name: "SENTRY_BASE_REPO_NAME",
                                       description: "The name of the base repository",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :head_ref,
                                       env_name: "SENTRY_HEAD_REF",
                                       description: "The name of the head branch",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :base_ref,
                                       env_name: "SENTRY_BASE_REF",
                                       description: "The name of the base branch",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :pr_number,
                                       env_name: "SENTRY_PR_NUMBER",
                                       description: "The pull request number",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :force_git_metadata,
                                       description: "Force collection and sending of git metadata (branch, commit, etc.). \
                                       If neither this nor --no-git-metadata is specified, git metadata is automatically \
                                       collected when running in most CI environments",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :no_git_metadata,
                                       description: "Disable collection and sending of git metadata",
                                       is_string: false,
                                       optional: true)
        ]
      end

      def self.build_vcs_command(command, params)
        command << "--head-sha" << params[:head_sha] if params[:head_sha]
        command << "--base-sha" << params[:base_sha] if params[:base_sha]
        command << "--vcs-provider" << params[:vcs_provider] if params[:vcs_provider]
        command << "--head-repo-name" << params[:head_repo_name] if params[:head_repo_name]
        command << "--base-repo-name" << params[:base_repo_name] if params[:base_repo_name]
        command << "--head-ref" << params[:head_ref] if params[:head_ref]
        command << "--base-ref" << params[:base_ref] if params[:base_ref]
        command << "--pr-number" << params[:pr_number] if params[:pr_number]
        command << "--force-git-metadata" if params[:force_git_metadata]
        command << "--no-git-metadata" if params[:no_git_metadata]
        command
      end

      def self.fallback_sentry_cli_auth(params)
        sentry_cli_result = JSON.parse(SentryHelper.call_sentry_cli(
                                         params,
                                         [
                                           "info",
                                           "--config-status-json"
                                         ]
                                       ))
        return (sentry_cli_result["auth"]["successful"] &&
          !sentry_cli_result["auth"]["type"].nil?)
      end
    end
  end
end
