module Fastlane
  module Actions
    class SentryUploadBuildAction < Action
      def self.run(params)
        Helper::SentryConfig.parse_api_params(params)

        # Determine which build file path to use (conflicting_options handles mutual exclusivity)
        build_path = nil
        build_type = nil

        if params[:xcarchive_path]
          build_path = params[:xcarchive_path]
          build_type = :xcarchive
        elsif params[:apk_path]
          build_path = params[:apk_path]
          build_type = :apk
        elsif params[:aab_path]
          build_path = params[:aab_path]
          build_type = :aab
        elsif params[:ipa_path]
          build_path = params[:ipa_path]
          build_type = :ipa
        else
          UI.user_error!("One of xcarchive_path, apk_path, aab_path, or ipa_path must be provided")
        end

        # Verify build file exists
        UI.user_error!("Could not find build file at path '#{build_path}'") unless File.exist?(build_path)

        # Verify file extension matches expected type
        case build_type
        when :xcarchive
          UI.user_error!("Path '#{build_path}' is not an xcarchive") unless File.extname(build_path) == '.xcarchive'
        when :apk
          UI.user_error!("Path '#{build_path}' is not an APK") unless File.extname(build_path).casecmp('.apk').zero?
        when :aab
          UI.user_error!("Path '#{build_path}' is not an AAB") unless File.extname(build_path).casecmp('.aab').zero?
        when :ipa
          UI.user_error!("Path '#{build_path}' is not an IPA") unless File.extname(build_path).casecmp('.ipa').zero?
        end

        command = [
          "build",
          "upload",
          File.absolute_path(build_path)
        ]

        # Add git-related parameters if provided
        command << "--head-sha" << params[:head_sha] if params[:head_sha]
        command << "--base-sha" << params[:base_sha] if params[:base_sha]
        command << "--vcs-provider" << params[:vcs_provider] if params[:vcs_provider]
        command << "--head-repo-name" << params[:head_repo_name] if params[:head_repo_name]
        command << "--base-repo-name" << params[:base_repo_name] if params[:base_repo_name]
        command << "--head-ref" << params[:head_ref] if params[:head_ref]
        command << "--base-ref" << params[:base_ref] if params[:base_ref]
        command << "--pr-number" << params[:pr_number] if params[:pr_number]
        command << "--build-configuration" << params[:build_configuration] if params[:build_configuration]
        command << "--release-notes" << params[:release_notes] if params[:release_notes]
        command << "--force-git-metadata" if params[:force_git_metadata]
        command << "--no-git-metadata" if params[:no_git_metadata]

        Helper::SentryHelper.call_sentry_cli(params, command)
        UI.success("Successfully uploaded build file: #{build_path}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload build files (iOS .xcarchive/.ipa or Android .apk/.aab) to Sentry with optional git context"
      end

      def self.details
        "This action allows you to upload build files to Sentry. Supported formats include iOS build archives (.xcarchive), iOS app bundles (.ipa), Android APK files (.apk), and Android App Bundles (.aab). The action supports optional git-related parameters for enhanced context including commit SHAs, branch names, repository information, and pull request details."
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :xcarchive_path,
                                       description: "Path to your iOS build archive (.xcarchive). Mutually exclusive with apk_path, aab_path, and ipa_path",
                                       default_value: Actions.lane_context[SharedValues::XCODEBUILD_ARCHIVE],
                                       optional: true,
                                       conflicting_options: [:apk_path, :aab_path, :ipa_path],
                                       verify_block: proc do |value|
                                         # Skip validation if value is nil or empty (will be validated in run method)
                                         next if value.nil? || value.to_s.empty?

                                         UI.user_error!("Could not find xcarchive at path '#{value}'") unless File.exist?(value)
                                         UI.user_error!("Path '#{value}' is not an xcarchive") unless File.extname(value) == '.xcarchive'
                                       end),
          FastlaneCore::ConfigItem.new(key: :apk_path,
                                       description: "Path to your Android APK file (.apk). Mutually exclusive with xcarchive_path, aab_path, and ipa_path",
                                       optional: true,
                                       conflicting_options: [:xcarchive_path, :aab_path, :ipa_path],
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find APK at path '#{value}'") unless File.exist?(value)
                                         UI.user_error!("Path '#{value}' is not an APK") unless File.extname(value).casecmp('.apk').zero?
                                       end),
          FastlaneCore::ConfigItem.new(key: :aab_path,
                                       description: "Path to your Android App Bundle (.aab). Mutually exclusive with xcarchive_path, apk_path, and ipa_path",
                                       optional: true,
                                       conflicting_options: [:xcarchive_path, :apk_path, :ipa_path],
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find AAB at path '#{value}'") unless File.exist?(value)
                                         UI.user_error!("Path '#{value}' is not an AAB") unless File.extname(value).casecmp('.aab').zero?
                                       end),
          FastlaneCore::ConfigItem.new(key: :ipa_path,
                                       description: "Path to your iOS app bundle (.ipa). Mutually exclusive with xcarchive_path, apk_path, and aab_path",
                                       optional: true,
                                       conflicting_options: [:xcarchive_path, :apk_path, :aab_path],
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find IPA at path '#{value}'") unless File.exist?(value)
                                         UI.user_error!("Path '#{value}' is not an IPA") unless File.extname(value).casecmp('.ipa').zero?
                                       end),
          FastlaneCore::ConfigItem.new(key: :head_sha,
                                       env_name: "SENTRY_HEAD_SHA",
                                       description: "The SHA of the head of the current branch",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :base_sha,
                                       env_name: "SENTRY_BASE_SHA",
                                       description: "The SHA of the base branch",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :vcs_provider,
                                       env_name: "SENTRY_VCS_PROVIDER",
                                       description: "The version control system provider (e.g., 'github', 'gitlab')",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :head_repo_name,
                                       env_name: "SENTRY_HEAD_REPO_NAME",
                                       description: "The name of the head repository",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :base_repo_name,
                                       env_name: "SENTRY_BASE_REPO_NAME",
                                       description: "The name of the base repository",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :head_ref,
                                       env_name: "SENTRY_HEAD_REF",
                                       description: "The name of the head branch",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :base_ref,
                                       env_name: "SENTRY_BASE_REF",
                                       description: "The name of the base branch",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :pr_number,
                                       env_name: "SENTRY_PR_NUMBER",
                                       description: "The pull request number",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :build_configuration,
                                       env_name: "SENTRY_BUILD_CONFIGURATION",
                                       description: "The build configuration (e.g., 'Release', 'Debug')",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :release_notes,
                                       description: "The release notes to use for the upload",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :force_git_metadata,
                                       description: "Force collection and sending of git metadata (branch, commit, etc.). \
                                       If neither this nor --no-git-metadata is specified, git metadata is automatically \
                                       collected when running in most CI environments",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :no_git_metadata,
                                       description: "Disable collection and sending of git metadata",
                                       is_string: false,
                                       optional: true)
        ]
      end

      def self.return_value
        nil
      end

      def self.authors
        ["runningcode"]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
