module Fastlane
  module Actions
    class SentryUploadProguardAction < Action
      def self.run(params)
        Helper::SentryHelper.check_sentry_cli!
        Helper::SentryConfig.parse_api_params(params)

        # Params - mapping & manifest
        mapping_path = params[:mapping_path]
        android_manifest_path = params[:android_manifest_path]

        has_manifest = !android_manifest_path.nil? && File.file?(android_manifest_path.to_s)

        # Verify files
        UI.user_error!("Mapping file does not exist at path: #{mapping_path}") unless File.exist? mapping_path

        # Create command
        command = %w[sentry-cli upload-proguard]
        command += ["--android-manifest", android_manifest_path] if has_manifest
        command += ["--app-id", params[:app_id]] unless params[:app_id].nil?
        command += ["--no-reprocessing"] if !!params[:no_reprocessing]
        command += ["--no-upload"] if !!params[:no_upload]
        command += ["--platform", params[:platform]] unless params[:platform].nil?
        command += ["--require-one"] if !!params[:require_one]
        command += ["--uuid", params[:uuid]] unless params[:uuid].nil?
        command += ["--version", params[:version]] unless params[:version].nil?
        command += ["--version-code", params[:version_code]] unless params[:version_code].nil?

        command += [mapping_path]

        Helper::SentryHelper.call_sentry_cli(command)
        UI.success("Successfully uploaded mapping file!")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload mapping to a project on Sentry"
      end

      def self.details
        [
          "This action allows you to upload the proguard mapping file to Sentry.",
          "See https://docs.sentry.io/cli/dif/proguard for more information."
        ].join(" ")
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :mapping_path,
                                       env_name: "ANDROID_MAPPING_PATH",
                                       description: "Path to your proguard mapping.txt file",
                                       optional: false,
                                       verify_block: proc do |value|
                                         UI.user_error! "Could not find your mapping file at path '#{value}'" unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :android_manifest_path,
                                       env_name: "ANDROID_MANIFEST_PATH",
                                       description: "Path to your merged AndroidManifest file. This is usually found under `app/build/intermediates/manifests/full`",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error! "Could not find your merged AndroidManifest file at path '#{value}'" unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :app_id,
                                       env_name: "APP_ID",
                                       description: "Associate the mapping files with an application ID",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :no_reprocessing,
                                       env_name: "NO_REPROCESSING",
                                       description: "Do not trigger reprocessing after upload",
                                       is_string: false,
                                       default_value: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :no_upload,
                                       env_name: "NO_UPLOAD",
                                       description: "Disable the actual upload",
                                       is_string: false,
                                       default_value: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :platform,
                                       env_name: "PLATFORM",
                                       description: "Optionally defines the platform for the app association. [defaults to 'android']",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :require_one,
                                       env_name: "REQUIRE_ONE",
                                       description: "Requires at least one file to upload or the command will error",
                                       is_string: false,
                                       default_value: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :uuid,
                                       env_name: "UUID",
                                       description: "Explicitly override the UUID of the mapping file with another one",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "VERSION_NAME",
                                       description: "Optionally associate the mapping files with a human readable version",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :version_code,
                                       env_name: "VERSION_CODE",
                                       description: "Optionally associate the mapping files with a version code",
                                       is_string: false,
                                       optional: true)
        ]
      end

      def self.return_value
        nil
      end

      def self.authors
        ["mpp-anasa"]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
