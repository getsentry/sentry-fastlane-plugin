module Fastlane
  module Helper
    class SentryConfig
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
                                       verify_block: proc do |value|
                                         UI.user_error!("No organization slug for SentryAction given, pass using `org_slug: 'org'`") unless value and !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :project_slug,
                                       env_name: "SENTRY_PROJECT_SLUG",
                                       description: "Project slug for Sentry",
                                       verify_block: proc do |value|
                                         UI.user_error!("No project slug for SentryAction given, pass using `project_slug: 'project'`") unless value and !value.empty?
                                       end)
        ]
      end

      def self.parse_api_params(params)
        require 'shellwords'

        url = params[:url]
        auth_token = params[:auth_token]
        api_key = params[:api_key]
        org = params[:org_slug]
        project = params[:project_slug]

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
        ENV['SENTRY_LOG_LEVEL'] = 'debug' if FastlaneCore::Globals.verbose?
        ENV['SENTRY_ORG'] = Shellwords.escape(org) unless org.to_s.empty?
        ENV['SENTRY_PROJECT'] = Shellwords.escape(project) unless project.to_s.empty?
      end
    end
  end
end
