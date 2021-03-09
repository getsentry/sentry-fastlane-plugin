module Fastlane
  module Actions
    class SentryUploadDifAction < Action
      def self.run(params)
        Helper::SentryHelper.check_sentry_cli!
        Helper::SentryConfig.parse_api_params(params)

        # Params - DIF
        dif_path = params[:dif_path]
        dif_paths = params[:dif_paths] || []

        # Verify dif(s)
        dif_paths += [dif_path] unless dif_path.nil?
        dif_paths = dif_paths.map { |path| File.absolute_path(path) }
        dif_paths.each do |path|
          UI.user_error!("File does not exist at path: #{path}") unless File.exist? path
        end

        command = ["sentry-cli", "upload-dif"]
        command.push("--include-sources") if params[:include_sources].nil?
        command.push("--symbol-maps") unless params[:symbol_maps].nil?
        command.push(params[:symbol_maps]) unless params[:symbol_maps].nil?
        command.push("--info-plist") unless params[:info_plist].nil?
        command.push(params[:info_plist]) unless params[:info_plist].nil?
        command += dif_paths

        Helper::SentryHelper.call_sentry_cli(command)
        UI.success("Successfully uploaded debugging information files!")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload debugging information files to Sentry"
      end

      def self.details
        [
          "This action allows you to upload symbolication files to Sentry.",
          "It's extra useful if you use it to download the latest dSYM files from Apple when you",
          "use Bitcode"
        ].join(" ")
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :dif_path,
                                      env_name: "SENTRY_DSYM_PATH",
                                      description: "Path to your symbols file. For iOS and Mac provide path to app.dSYM.zip",
                                      default_value: Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH],
                                      optional: true,
                                      verify_block: proc do |value|
                                        UI.user_error! "Could not find Path to your symbols file at path '#{value}'" unless File.exist?(value)
                                      end),
          FastlaneCore::ConfigItem.new(key: :dif_paths,
                                       env_name: "SENTRY_DSYM_PATHS",
                                       description: "Path to an array of your symbols file. For iOS and Mac provide path to app.dSYM.zip",
                                       default_value: Actions.lane_context[SharedValues::DSYM_PATHS],
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :symbol_maps,
                                      env_name: "SENTRY_SYMBOL_MAPS",
                                      description: "Optional path to bcsymbolmap files which are used to resolve hidden symbols in the actual dsym files. This requires the dsymutil tool to be available",
                                      optional: true,
                                      verify_block: proc do |value|
                                        UI.user_error! "Could not find bcsymbolmap at path '#{value}'" unless File.exist?(value)
                                      end),
          FastlaneCore::ConfigItem.new(key: :info_plist,
                                      env_name: "SENTRY_INFO_PLIST",
                                      description: "Optional path to Info.plist to add version information when uploading debug symbols",
                                      optional: true,
                                      verify_block: proc do |value|
                                        UI.user_error! "Could not find Info.plist at path '#{value}'" unless File.exist?(value)
                                      end)
        ]
      end

      def self.return_value
        nil
      end

      def self.authors
        ["joshdholtz", "HazAT"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
