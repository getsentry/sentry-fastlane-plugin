module Fastlane
  module Actions
    class SentryUploadDifAction < Action
      def self.run(params)
        require 'shellwords'

        Helper::SentryHelper.check_sentry_cli!
        Helper::SentryConfig.parse_api_params(params)

        # paths
        # types
        # no_unwind
        # no_debug
        # no_sources
        # ids
        # require_all
        # symbol_maps
        # derived_data
        # no_zips
        # info_plist
        # no_reprocessing
        # force_foreground
        # include_sources
        # wait
        # upload_symbol_maps

        command = [
          "sentry-cli",
          "upload-dif"
        ]
        command.push('--paths').push(params[:paths]) unless params[:paths].nil?

        Helper::SentryHelper.call_sentry_cli(command)
        UI.success("Successfully ran upload-dif")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload debugging information files."
      end

      def self.details
        [
          "Files can be uploaded using the upload-dif command. This command will scan a given folder recursively for files and upload them to Sentry.",
          "See https://docs.sentry.io/platforms/native/data-management/debug-files/upload/ for more information."
        ].join(" ")
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :paths,
                                       description: "A path to search recursively for symbol files"),
          # FastlaneCore::ConfigItem.new(key: :name,
          #                              short_option: "-n",
          #                              description: "Optional human readable name for this deployment",
          #                              optional: true),
          # FastlaneCore::ConfigItem.new(key: :deploy_url,
          #                              description: "Optional URL that points to the deployment",
          #                              optional: true),
          # FastlaneCore::ConfigItem.new(key: :started,
          #                              description: "Optional unix timestamp when the deployment started",
          #                              is_string: false,
          #                              optional: true),
          # FastlaneCore::ConfigItem.new(key: :finished,
          #                              description: "Optional unix timestamp when the deployment finished",
          #                              is_string: false,
          #                              optional: true),
          # FastlaneCore::ConfigItem.new(key: :time,
          #                              short_option: "-t",
          #                              description: "Optional deployment duration in seconds. This can be specified alternatively to `started` and `finished`",
          #                              is_string: false,
          #                              optional: true),
          # FastlaneCore::ConfigItem.new(key: :app_identifier,
          #                              short_option: "-a",
          #                              env_name: "SENTRY_APP_IDENTIFIER",
          #                              description: "App Bundle Identifier, prepended with the version.\nFor example bundle@version",
          #                              optional: true)
        ]
      end

      def self.return_value
        nil
      end

      def self.authors
        ["denrase"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
