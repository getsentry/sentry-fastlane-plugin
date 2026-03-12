module Fastlane
  module Actions
    class SentryUploadSnapshotsAction < Action
      def self.run(params)
        Helper::SentryConfig.parse_api_params(params)

        path = params[:path]
        app_id = params[:app_id]

        UI.user_error!("Path does not exist: #{path}") unless File.exist?(path)
        UI.user_error!("Path is not a directory: #{path}") unless File.directory?(path)

        command = [
          "build",
          "snapshots",
          "--app-id",
          app_id,
          path
        ]

        command << "--head-sha" << params[:head_sha] if params[:head_sha]
        command << "--base-sha" << params[:base_sha] if params[:base_sha]
        command << "--vcs-provider" << params[:vcs_provider] if params[:vcs_provider]
        command << "--head-repo-name" << params[:head_repo_name] if params[:head_repo_name]
        command << "--base-repo-name" << params[:base_repo_name] if params[:base_repo_name]
        command << "--head-ref" << params[:head_ref] if params[:head_ref]
        command << "--base-ref" << params[:base_ref] if params[:base_ref]
        command << "--pr-number" << params[:pr_number] if params[:pr_number]
        command << "--force-git-metadata" if params[:force_git_metadata]
        command << "--no-git-metadata" if params[:no_git_metadata]

        Helper::SentryHelper.call_sentry_cli(params, command)
        UI.success("Successfully uploaded snapshots!")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload snapshot images to Sentry (EXPERIMENTAL)"
      end

      def self.details
        "This action allows you to upload snapshot images to Sentry to check for visual regressions. NOTE: This features is experimental and might be changed in future releases."
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :path,
                                       description: "Path to the folder containing snapshot images",
                                       optional: false,
                                       verify_block: proc do |value|
                                                       UI.user_error! "Could not find path '#{value}'" unless File.exist?(value)
                                                       UI.user_error! "Path is not a directory: '#{value}'" unless File.directory?(value)
                                                     end),
          FastlaneCore::ConfigItem.new(key: :app_id,
                                       description: "Application identifier",
                                       optional: false),
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
        ["sentry"]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
