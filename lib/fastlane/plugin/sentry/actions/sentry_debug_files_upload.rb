module Fastlane
  module Actions
    class SentryDebugFilesUploadAction < Action
      def self.run(params)
        require 'shellwords'

        Helper::SentryConfig.parse_api_params(params)

        paths = params[:path]
        # Use DSYM_OUTPUT_PATH from fastlane context if available, otherwise default to current directory
        if paths.nil?
          dsym_path = Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH]
          if dsym_path && !dsym_path.to_s.empty?
            paths = [dsym_path]
          else
            paths = ['.']
          end
        end

        command = [
          "debug-files",
          "upload"
        ]
        command += paths

        command.push('--type').push(params[:type]) unless params[:type].nil?
        command.push('--no-unwind') unless params[:no_unwind].nil?
        command.push('--no-debug') unless params[:no_debug].nil?
        command.push('--no-sources') unless params[:no_sources].nil?
        command.push('--id').push(params[:id]) unless params[:id].nil?
        command.push('--require-all') unless params[:require_all].nil?
        command.push('--symbol-maps').push(params[:symbol_maps]) unless params[:symbol_maps].nil?
        command.push('--derived-data') unless params[:derived_data].nil?
        command.push('--no-zips') unless params[:no_zips].nil?
        command.push('--no-upload') unless params[:no_upload].nil?
        command.push('--include-sources') if params[:include_sources] == true
        command.push('--wait') unless params[:wait].nil?
        command.push('--wait-for').push(params[:wait_for]) unless params[:wait_for].nil?
        command.push('--il2cpp-mapping') unless params[:il2cpp_mapping].nil?

        Helper::SentryHelper.call_sentry_cli(params, command)
        UI.success("Successfully ran debug-files upload")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload debugging information files."
      end

      def self.details
        [
          "Files can be uploaded using the `debug-files upload` command. This command will scan a given folder recursively for files and upload them to Sentry.",
          "See https://docs.sentry.io/product/cli/dif/#uploading-files for more information."
        ].join(" ")
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :path,
                                       description: "Path or an array of paths to search recursively for symbol files. Defaults to DSYM_OUTPUT_PATH from fastlane context if available, otherwise '.' (current directory)",
                                       type: Array,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :type,
                                       short_option: "-t",
                                       description: "Only consider debug information files of the given \
                                       type.  By default, all types are considered",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error! "Invalid value '#{value}'" unless ['bcsymbolmap', 'breakpad', 'dsym', 'elf', 'jvm', 'pdb', 'pe', 'portablepdb', 'sourcebundle', 'wasm'].include? value
                                       end),
          FastlaneCore::ConfigItem.new(key: :no_unwind,
                                       description: "Do not scan for stack unwinding information. Specify \
                                       this flag for builds with disabled FPO, or when \
                                       stackwalking occurs on the device. This usually \
                                       excludes executables and dynamic libraries. They might \
                                       still be uploaded, if they contain additional \
                                       processable information (see other flags)",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :no_debug,
                                       description: "Do not scan for debugging information. This will \
                                       usually exclude debug companion files. They might \
                                       still be uploaded, if they contain additional \
                                       processable information (see other flags)",
                                       conflicting_options: [:no_unwind],
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :no_sources,
                                       description: "Do not scan for source information. This will \
                                       usually exclude source bundle files. They might \
                                       still be uploaded, if they contain additional \
                                       processable information (see other flags)",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :id,
                                       description: "Search for specific debug identifiers",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :require_all,
                                       description: "Errors if not all identifiers specified with --id could be found",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :symbol_maps,
                                       description: "Optional path to BCSymbolMap files which are used to \
                                       resolve hidden symbols in dSYM files downloaded from \
                                       iTunes Connect. This requires the dsymutil tool to be \
                                       available",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :derived_data,
                                       description: "Search for debug symbols in Xcode's derived data",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :no_zips,
                                       description: "Do not search in ZIP files",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :no_upload,
                                       description: "Disable the actual upload. This runs all steps for the \
                                       processing but does not trigger the upload. This is useful if \
                                       you just want to verify the setup or skip the upload in tests",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :include_sources,
                                       description: "Include sources from the local file system and upload \
                                       them as source bundles",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :wait,
                                       description: "Wait for the server to fully process uploaded files. Errors \
                                       can only be displayed if --wait or --wait-for is specified, but this will \
                                       significantly slow down the upload process",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :wait_for,
                                       description: "Wait for the server to fully process uploaded files, but at most \
                                       for the given number of seconds. Errors can only be displayed if --wait or \
                                       --wait-for is specified, but this will significantly slow down the upload process",
                                       type: Integer,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :il2cpp_mapping,
                                       description: "Compute il2cpp line mappings and upload them along with sources",
                                       is_string: false,
                                       optional: true)
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
