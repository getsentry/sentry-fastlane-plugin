module Fastlane
  module Actions
    class SentryUploadSourcemapAction < Action
      def self.run(params)
        require 'shellwords'

        Helper::SentryConfig.parse_api_params(params)

        version = params[:version]
        version = "#{params[:app_identifier]}@#{params[:version]}" if params[:app_identifier]
        version = "#{version}+#{params[:build]}" if params[:build]

        options = []
        options.push('--no-rewrite') unless params[:rewrite]
        options.push('--strip-prefix').push(params[:strip_prefix]) if params[:strip_prefix]
        options.push('--strip-common-prefix') if params[:strip_common_prefix]
        options.push('--url-prefix').push(params[:url_prefix]) unless params[:url_prefix].nil?
        options.push('--dist').push(params[:dist]) unless params[:dist].nil?

        ignore = normalize_list(params[:ignore])
        options.push('--ignore').push(ignore.join(',')) unless ignore.empty?
        options.push('--ignore-file').push(params[:ignore_file]) unless params[:ignore_file].nil?

        ext = normalize_list(params[:ext])
        options.push('--ext').push(ext.join(',')) unless ext.empty?

        # The Sentry CLI uploads one directory per invocation
        params[:sourcemap].each do |directory|
          command = ["sourcemap", "upload", "--release", version, directory] + options
          Helper::SentryHelper.call_sentry_cli(params, command)
        end
        UI.success("Successfully uploaded files to release: #{version}")
      end

      # Accepts a single value or an array and returns an array without nil or blank entries
      def self.normalize_list(value)
        [*value].map { |entry| entry.to_s.strip }.reject(&:empty?)
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload one or more sourcemap(s) to a release of a project on Sentry"
      end

      def self.details
        [
          "This action allows you to upload one or more sourcemap(s) to a release of a project on Sentry.",
          "See https://docs.sentry.io/learn/cli/releases/#upload-sourcemaps for more information."
        ].join(" ")
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: "Release version on Sentry"),
          FastlaneCore::ConfigItem.new(key: :app_identifier,
                                       short_option: "-a",
                                       env_name: "SENTRY_APP_IDENTIFIER",
                                       description: "App Bundle Identifier, prepended to version",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :build,
                                       short_option: "-b",
                                       description: "Release build on Sentry",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :dist,
                                       description: "Distribution in release",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :sourcemap,
                                       description: "Directory or an array of directories containing the sourcemaps to upload. Each directory is uploaded in a separate Sentry CLI invocation",
                                       type: Array,
                                       verify_block: proc do |values|
                                         [*values].each do |value|
                                           UI.user_error! "Could not find sourcemap at path '#{value}'" unless File.exist?(value)
                                         end
                                       end),
          FastlaneCore::ConfigItem.new(key: :rewrite,
                                       description: "Rewrite the sourcemaps before upload",
                                       default_value: false,
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :strip_prefix,
                                       conflicting_options: [:strip_common_prefix],
                                       description: "Chop-off a prefix from uploaded files. Strips the given prefix from all \
                                       sources references inside the upload sourcemaps (paths used within the sourcemap \
                                       content, to map minified code to it's original source). Only sources that start \
                                       with the given prefix will be stripped. This will not modify the uploaded sources \
                                       paths",
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
          FastlaneCore::ConfigItem.new(key: :url_suffix,
                                       deprecated: "The Sentry CLI no longer supports `--url-suffix`, this option is ignored",
                                       description: "Sets a URL suffix to append to all filenames",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :note,
                                       deprecated: "The Sentry CLI no longer supports `--note`, this option is ignored",
                                       description: "Adds an optional note to the uploaded artifact bundle",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :validate,
                                       deprecated: "The Sentry CLI no longer supports `--validate`, this option is ignored",
                                       description: "Enable basic sourcemap validation",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :decompress,
                                       deprecated: "The Sentry CLI no longer supports `--decompress`, this option is ignored",
                                       description: "Enable files gzip decompression prior to upload",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :wait,
                                       deprecated: "The Sentry CLI no longer supports `--wait`, this option is ignored",
                                       description: "Wait for the server to fully process uploaded files",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :wait_for,
                                       deprecated: "The Sentry CLI no longer supports `--wait-for`, this option is ignored",
                                       description: "Wait for the server to fully process uploaded files, but at most \
                                       for the given number of seconds",
                                       type: Integer,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :no_sourcemap_reference,
                                       deprecated: "The Sentry CLI no longer supports `--no-sourcemap-reference`, this option is ignored",
                                       description: "Disable emitting of automatic sourcemap references. By default the \
                                       tool will store a 'Sourcemap' header with minified files so that sourcemaps \
                                       are located automatically if the tool can detect a link. If this causes issues \
                                       it can be disabled",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :debug_id_reference,
                                       deprecated: "The Sentry CLI now always uses the debug ID of the linked sourcemap, this option is ignored",
                                       description: "Enable emitting of automatic debug id references. By default Debug ID \
                                       reference has to be present both in the source and the related sourcemap. But in \
                                       cases of binary bundles, the tool can't verify presence of the Debug ID. This flag \
                                       allows use of Debug ID from the linked sourcemap",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :bundle,
                                       deprecated: "The Sentry CLI no longer supports `--bundle`, this option is ignored",
                                       description: "Path to the application bundle (indexed, file, or regular)",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :bundle_sourcemap,
                                       deprecated: "The Sentry CLI no longer supports `--bundle-sourcemap`, this option is ignored",
                                       description: "Path to the bundle sourcemap",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :ext,
                                       description: "File extension or array of file extensions that are considered for upload. This overrides \
                                       the default extensions. To add an extension, all default extensions must be repeated. \
                                       Defaults to: js, cjs, mjs",
                                       type: Array,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :strict,
                                       deprecated: "The Sentry CLI no longer supports `--strict`, this option is ignored",
                                       description: "Fail with a non-zero exit code if the specified source map file cannot be uploaded",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :ignore,
                                       description: "Ignores all files and folders matching the given glob or array of globs (globs must not contain commas)",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :ignore_file,
                                       description: "Ignore all files and folders specified in the given ignore file, e.g. .gitignore",
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
