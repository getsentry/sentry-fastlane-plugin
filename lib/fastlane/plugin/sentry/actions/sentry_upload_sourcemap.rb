module Fastlane
  module Actions
    class SentryUploadSourcemapAction < Action
      def self.run(params)
        require 'shellwords'

        Helper::SentryConfig.parse_api_params(params)

        version = params[:version]
        version = "#{params[:app_identifier]}@#{params[:version]}" if params[:app_identifier]
        version = "#{version}+#{params[:build]}" if params[:build]

        sourcemaps = params[:sourcemap]

        command = [
          "sourcemaps",
          "upload",
          "--release",
          version
        ]
        command += sourcemaps

        command.push('--no-rewrite') unless params[:rewrite]
        command.push('--strip-prefix').push(params[:strip_prefix]) if params[:strip_prefix]
        command.push('--strip-common-prefix') if params[:strip_common_prefix]
        command.push('--url-prefix').push(params[:url_prefix]) unless params[:url_prefix].nil?
        command.push('--url-suffix').push(params[:url_suffix]) unless params[:url_suffix].nil?
        command.push('--dist').push(params[:dist]) unless params[:dist].nil?
        command.push('--note').push(params[:note]) unless params[:note].nil?
        command.push('--validate') if params[:validate]
        command.push('--decompress') if params[:decompress]
        command.push('--wait') if params[:wait]
        command.push('--wait-for').push(params[:wait_for]) unless params[:wait_for].nil?
        command.push('--no-sourcemap-reference') if params[:no_sourcemap_reference]
        command.push('--debug-id-reference') if params[:debug_id_reference]
        command.push('--bundle').push(params[:bundle]) unless params[:bundle].nil?
        command.push('--bundle-sourcemap').push(params[:bundle_sourcemap]) unless params[:bundle_sourcemap].nil?
        command.push('--strict') if params[:strict]

        unless params[:ignore].nil?
          # normalize to array
          unless params[:ignore].kind_of?(Enumerable)
            params[:ignore] = [params[:ignore]]
          end
          # no nil or empty strings
          params[:ignore].reject! do |e|
            e.strip.empty?
          rescue StandardError
            true
          end
          params[:ignore].each do |pattern|
            command.push('--ignore').push(pattern)
          end
        end

        command.push('--ignore-file').push(params[:ignore_file]) unless params[:ignore_file].nil?

        unless params[:ext].nil?
          # normalize to array
          unless params[:ext].kind_of?(Enumerable)
            params[:ext] = [params[:ext]]
          end
          params[:ext].each do |extension|
            command.push('--ext').push(extension)
          end
        end

        Helper::SentryHelper.call_sentry_cli(params, command)
        UI.success("Successfully uploaded files to release: #{version}")
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
                                       description: "Path or an array of paths to the sourcemap(s) to upload",
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
                                       description: "Sets a URL suffix to append to all filenames",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :note,
                                       description: "Adds an optional note to the uploaded artifact bundle",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :validate,
                                       description: "Enable basic sourcemap validation",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :decompress,
                                       description: "Enable files gzip decompression prior to upload",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :wait,
                                       description: "Wait for the server to fully process uploaded files",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :wait_for,
                                       description: "Wait for the server to fully process uploaded files, but at most \
                                       for the given number of seconds",
                                       type: Integer,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :no_sourcemap_reference,
                                       description: "Disable emitting of automatic sourcemap references. By default the \
                                       tool will store a 'Sourcemap' header with minified files so that sourcemaps \
                                       are located automatically if the tool can detect a link. If this causes issues \
                                       it can be disabled",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :debug_id_reference,
                                       description: "Enable emitting of automatic debug id references. By default Debug ID \
                                       reference has to be present both in the source and the related sourcemap. But in \
                                       cases of binary bundles, the tool can't verify presence of the Debug ID. This flag \
                                       allows use of Debug ID from the linked sourcemap",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :bundle,
                                       description: "Path to the application bundle (indexed, file, or regular)",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :bundle_sourcemap,
                                       description: "Path to the bundle sourcemap",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :ext,
                                       description: "Set the file extensions that are considered for upload. This overrides \
                                       the default extensions. To add an extension, all default extensions must be repeated. \
                                       Specify once per extension. Defaults to: js, cjs, mjs, map, jsbundle, bundle",
                                       type: Array,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :strict,
                                       description: "Fail with a non-zero exit code if the specified source map file cannot be uploaded",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :ignore,
                                       description: "Ignores all files and folders matching the given glob or array of globs",
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
