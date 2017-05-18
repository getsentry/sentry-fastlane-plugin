module Fastlane
  module Actions
    class SentryUploadSourcemapAction < Action
      def self.run(params)
        require 'shellwords'

        Helper::SentryHelper.check_sentry_cli!
        Helper::SentryConfig.parse_api_params(params)

        version = params[:version]
        sourcemap = params[:sourcemap]

        rewrite_arg = params[:rewrite] ? '--rewrite' : ''
        strip_prefix_arg = params[:strip_prefix] ? '--strip-prefix' : ''
        strip_common_prefix_arg = params[:strip_common_prefix] ? '--strip-common-prefix' : ''
        url_prefix_arg = params[:url_prefix] ? "--url-prefix '#{params[:url_prefix]}'" : ''
        dist_arg = params[:dist] ? "--dist '#{params[:dist]}'" : ''

        command = [
          "sentry-cli",
          "releases",
          "files",
          "'#{Shellwords.escape(version)}'",
          "upload-sourcemaps",
          sourcemap.to_s,
          rewrite_arg,
          strip_prefix_arg,
          strip_common_prefix_arg,
          url_prefix_arg,
          dist_arg
        ].join(" ")

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
                                       description: "Distribution in release"),
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
                                       optional: true)
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
