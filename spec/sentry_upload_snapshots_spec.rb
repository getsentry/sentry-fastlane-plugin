describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload snapshots" do
      it "fails with non-existent path" do
        path = File.absolute_path './assets/this_does_not_exist'

        expect do
          described_class.new.parse("lane :test do
            sentry_upload_snapshots(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              app_id: 'com.example.app',
              path: '#{path}')
          end").runner.execute(:test)
        end.to raise_error("Could not find path '#{path}'")
      end

      it "fails when path is a file, not a directory" do
        path = File.absolute_path './assets/AndroidExample.mapping.txt'

        expect do
          described_class.new.parse("lane :test do
            sentry_upload_snapshots(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              app_id: 'com.example.app',
              path: '#{path}')
          end").runner.execute(:test)
        end.to raise_error("Path is not a directory: '#{path}'")
      end

      it "builds correct command with required params" do
        Dir.mktmpdir do |path|
          expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
          expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
            anything, ["build", "snapshots", "--app-id", "com.example.app", path]
          ).and_return(true)

          described_class.new.parse("lane :test do
              sentry_upload_snapshots(
                org_slug: 'some_org',
                auth_token: 'something123',
                project_slug: 'some_project',
                app_id: 'com.example.app',
                path: '#{path}')
          end").runner.execute(:test)
        end
      end

      it "passes VCS parameters to the CLI command" do
        Dir.mktmpdir do |path|
          expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
          expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
            anything,
            ["build", "snapshots", "--app-id", "com.example.app", path,
             "--head-sha", "abc123", "--base-sha", "def456",
             "--vcs-provider", "github", "--head-repo-name", "test/repo",
             "--base-repo-name", "test/repo", "--head-ref", "feature",
             "--base-ref", "main", "--pr-number", "123"]
          ).and_return(true)

          described_class.new.parse("lane :test do
              sentry_upload_snapshots(
                org_slug: 'some_org',
                auth_token: 'something123',
                project_slug: 'some_project',
                app_id: 'com.example.app',
                path: '#{path}',
                head_sha: 'abc123',
                base_sha: 'def456',
                vcs_provider: 'github',
                head_repo_name: 'test/repo',
                base_repo_name: 'test/repo',
                head_ref: 'feature',
                base_ref: 'main',
                pr_number: '123')
          end").runner.execute(:test)
        end
      end

      it "includes --force-git-metadata when true" do
        Dir.mktmpdir do |path|
          expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
          expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
            anything,
            ["build", "snapshots", "--app-id", "com.example.app", path, "--force-git-metadata"]
          ).and_return(true)

          described_class.new.parse("lane :test do
              sentry_upload_snapshots(
                org_slug: 'some_org',
                auth_token: 'something123',
                project_slug: 'some_project',
                app_id: 'com.example.app',
                path: '#{path}',
                force_git_metadata: true)
          end").runner.execute(:test)
        end
      end

      it "includes --no-git-metadata when true" do
        Dir.mktmpdir do |path|
          expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
          expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
            anything,
            ["build", "snapshots", "--app-id", "com.example.app", path, "--no-git-metadata"]
          ).and_return(true)

          described_class.new.parse("lane :test do
              sentry_upload_snapshots(
                org_slug: 'some_org',
                auth_token: 'something123',
                project_slug: 'some_project',
                app_id: 'com.example.app',
                path: '#{path}',
                no_git_metadata: true)
          end").runner.execute(:test)
        end
      end
    end
  end
end
