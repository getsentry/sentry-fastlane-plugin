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
                                       end),
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
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       env_name: "SENTRY_API_KEY",
                                       description: "API key for Sentry",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :org_slug,
                                       env_name: "SENTRY_ORG_SLUG",
                                       description: "Organization slug for Sentry project",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :project_slug,
                                       env_name: "SENTRY_PROJECT_SLUG",
                                       description: "Project slug for Sentry",
                                       optional: true),
        ] + self.common_cli_config_items
      end

      def self.parse_api_params(params)
        require 'shellwords'

        url = params[:url]
        auth_token = params[:auth_token]
        api_key = params[:api_key]
        org = params[:org_slug]
        project = params[:project_slug]

        has_org = !org.to_s.empty?
        has_project = !project.to_s.empty?
        has_api_key = !api_key.to_s.empty?
        has_auth_token = !auth_token.to_s.empty?

        ENV['SENTRY_URL'] = url unless url.to_s.empty?
        ENV['SENTRY_LOG_LEVEL'] = 'DEBUG' if FastlaneCore::Globals.verbose?

        # Fallback to .sentryclirc if possible when no auth token is provided
        if !has_api_key && !has_auth_token && fallback_sentry_cli_auth(params)
            UI.important("No auth config provided, will fallback to .sentryclirc")
        else
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
        end

        if has_org && has_project
          ENV['SENTRY_ORG'] = Shellwords.escape(org) unless org.to_s.empty?
          ENV['SENTRY_PROJECT'] = Shellwords.escape(project) unless project.to_s.empty?
        else
          UI.important("No org/project config provided, will fallback to .sentryclirc")
        end
      end

      def self.fallback_sentry_cli_auth(params)
        sentry_cli_result = JSON.parse(SentryHelper.call_sentry_cli(
          params, 
          [
            "info", 
            "--config-status-json",
          ]
        ))
        return (sentry_cli_result["auth"]["successful"] &&
          !sentry_cli_result["auth"]["type"].nil?)
      end
    end
  end
end
