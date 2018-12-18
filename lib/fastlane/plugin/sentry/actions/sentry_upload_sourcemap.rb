module Fastlane
  module Actions
    class SentryUploadSourcemapAction < Action
      def self.run(params)
        require 'shellwords'

        Helper::SentryHelper.check_sentry_cli(params[:sentry_cli_path])
        Helper::SentryConfig.parse_api_params(params)

        version = params[:version]
        sourcemap = params[:sourcemap]

        version = "#{params[:app_identifier]}-#{params[:version]}" if params[:app_identifier]

        sentry_cli = "sentry-cli"
        unless params[:sentry_cli_path].nil?
            sentry_cli = params[:sentry_cli_path]
        end
        command = [
          sentry_cli,
          "releases",
          "files",
          Shellwords.escape(version),
          "upload-sourcemaps",
          sourcemap.to_s
        ]

        command.push('--rewrite') if params[:rewrite]
        command.push('--strip-prefix') if params[:strip_prefix]
        command.push('--strip-common-prefix') if params[:strip_common_prefix]
        command.push('--url-prefix').push(params[:url_prefix]) unless params[:url_prefix].nil?
        command.push('--dist').push(params[:dist]) unless params[:dist].nil?

        Helper::SentryHelper.call_sentry_cli(command)
        UI.success("Successfully uploaded files to release: #{version}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload a sourcemap to a release of a project on Sentry"
      end

      def self.details
        [
          "This action allows you to upload a sourcemap to a release of a project on Sentry.",
          "See https://docs.sentry.io/learn/cli/releases/#upload-sourcemaps for more information."
        ].join(" ")
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: "Release version on Sentry"),
          FastlaneCore::ConfigItem.new(key: :dist,
                                       description: "Distribution in release",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :sourcemap,
                                       description: "Path to the sourcemap to upload",
                                       verify_block: proc do |value|
                                         UI.user_error! "Could not find sourcemap at path '#{value}'" unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :rewrite,
                                       description: "Rewrite the sourcemaps before upload",
                                       default_value: false,
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :strip_prefix,
                                       conflicting_options: [:strip_common_prefix],
                                       description: "Chop-off a prefix from uploaded files",
                                       default_value: false,
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :strip_common_prefix,
                                       conflicting_options: [:strip_prefix],
                                       description: "Automatically guess what the common prefix is and chop that one off",
                                       default_value: false,
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :url_prefix,
                                       description: "Sets a URL prefix in front of all files",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :app_identifier,
                                       short_option: "-a",
                                       env_name: "SENTRY_APP_IDENTIFIER",
                                       description: "App Bundle Identifier, prepended to version",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :sentry_cli_path,
                                     env_name: "SENTRY_CLI_PATH",
                                      description: "Path to your sentry-cli. Default to `which sentry-cli`",
                                      optional: true,
                                      verify_block: proc do |value|
                                        UI.user_error! "Could not find sentry-cli." unless File.exist?(File.expand_path(value))
                                      end),

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
