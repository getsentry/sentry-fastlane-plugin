module Fastlane
  module Actions
    def self.lane_context
      @lane_context ||= {}
    end
  end

  module SharedValues
    XCODEBUILD_ARCHIVE = :xcodebuild_archive unless defined?(XCODEBUILD_ARCHIVE)
  end
end

describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload build" do
      # We'll use the dSYM file as a mock xcarchive for testing since we need an existing file
      let(:mock_xcarchive_path) { File.absolute_path './assets/SwiftExample.app.dSYM.zip' }

      it "fails when xcarchive path does not exist" do
        non_existent_path = './assets/NonExistent.xcarchive'

        expect do
          described_class.new.parse("lane :test do
            sentry_upload_build(
              auth_token: 'test-token',
              org_slug: 'test-org',
              project_slug: 'test-project',
              xcarchive_path: '#{non_existent_path}')
          end").runner.execute(:test)
        end.to raise_error("Could not find xcarchive at path '#{non_existent_path}'")
      end

      it "fails when file is not an xcarchive" do
        # Mock a file that exists but doesn't have .xcarchive extension
        invalid_archive_path = './assets/test.zip'

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with(invalid_archive_path).and_return(true)

        expect do
          described_class.new.parse("lane :test do
            sentry_upload_build(
              auth_token: 'test-token',
              org_slug: 'test-org',
              project_slug: 'test-project',
              xcarchive_path: '#{invalid_archive_path}')
          end").runner.execute(:test)
        end.to raise_error("Path '#{invalid_archive_path}' is not an xcarchive")
      end

      it "calls sentry-cli with basic parameters" do
        # Mock the file to have .xcarchive extension
        mock_path = './assets/Test.xcarchive'

        allow(File).to receive(:exist?).with(mock_path).and_return(true)
        allow(File).to receive(:extname).with(mock_path).and_return('.xcarchive')

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          anything,
          ["build", "upload", anything]
        ).and_return(true)

        described_class.new.parse("lane :test do
          sentry_upload_build(
            auth_token: 'test-token',
            org_slug: 'test-org',
            project_slug: 'test-project',
            xcarchive_path: '#{mock_path}')
        end").runner.execute(:test)
      end

      it "uses SharedValues::XCODEBUILD_ARCHIVE as default if xcarchive_path is not provided" do
        require 'fastlane'
        mock_path = './assets/Test.xcarchive'

        # Set the shared value on the correct module BEFORE parsing the lane
        Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = mock_path

        # Stubs for file checks
        allow(File).to receive(:exist?).with(mock_path).and_return(true)
        allow(File).to receive(:exist?).with("").and_return(false)
        allow(File).to receive(:extname).with(mock_path).and_return('.xcarchive')
        allow(File).to receive(:extname).with("").and_return('')

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          anything,
          ["build", "upload", anything]
        ).and_return(true)

        described_class.new.parse("lane :test do
          sentry_upload_build(
            auth_token: 'test-token',
            org_slug: 'test-org',
            project_slug: 'test-project')
        end").runner.execute(:test)
      end

      it "calls sentry-cli with git parameters when provided" do
        mock_path = './assets/Test.xcarchive'

        allow(File).to receive(:exist?).with(mock_path).and_return(true)
        allow(File).to receive(:extname).with(mock_path).and_return('.xcarchive')

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          anything,
          ["build", "upload", anything, "--head-sha", "abc123", "--base-sha", "def456", "--vcs-provider", "github", "--head-repo-name", "test/repo", "--base-repo-name", "test/repo", "--head-ref", "feature", "--base-ref", "main", "--pr-number", "123", "--build-configuration", "Release"]
        ).and_return(true)

        described_class.new.parse("lane :test do
          sentry_upload_build(
            auth_token: 'test-token',
            org_slug: 'test-org',
            project_slug: 'test-project',
            xcarchive_path: '#{mock_path}',
            head_sha: 'abc123',
            base_sha: 'def456',
            vcs_provider: 'github',
            head_repo_name: 'test/repo',
            base_repo_name: 'test/repo',
            head_ref: 'feature',
            base_ref: 'main',
            pr_number: '123',
            build_configuration: 'Release')
        end").runner.execute(:test)
      end

      it "reads git parameters from environment variables when set" do
        mock_path = './assets/Test.xcarchive'

        allow(File).to receive(:exist?).with(mock_path).and_return(true)
        allow(File).to receive(:extname).with(mock_path).and_return('.xcarchive')

        # Set environment variables
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('SENTRY_HEAD_SHA').and_return('env_abc123')
        allow(ENV).to receive(:[]).with('SENTRY_BASE_SHA').and_return('env_def456')
        allow(ENV).to receive(:[]).with('SENTRY_VCS_PROVIDER').and_return('env_gitlab')
        allow(ENV).to receive(:[]).with('SENTRY_HEAD_REPO_NAME').and_return('env_test/repo')
        allow(ENV).to receive(:[]).with('SENTRY_BASE_REPO_NAME').and_return('env_base/repo')
        allow(ENV).to receive(:[]).with('SENTRY_HEAD_REF').and_return('env_feature')
        allow(ENV).to receive(:[]).with('SENTRY_BASE_REF').and_return('env_main')
        allow(ENV).to receive(:[]).with('SENTRY_PR_NUMBER').and_return('env_456')
        allow(ENV).to receive(:[]).with('SENTRY_BUILD_CONFIGURATION').and_return('env_Debug')

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          anything,
          ["build", "upload", anything, "--head-sha", "env_abc123", "--base-sha", "env_def456", "--vcs-provider", "env_gitlab", "--head-repo-name", "env_test/repo", "--base-repo-name", "env_base/repo", "--head-ref", "env_feature", "--base-ref", "env_main", "--pr-number", "env_456", "--build-configuration", "env_Debug"]
        ).and_return(true)

        described_class.new.parse("lane :test do
          sentry_upload_build(
            auth_token: 'test-token',
            org_slug: 'test-org',
            project_slug: 'test-project',
            xcarchive_path: '#{mock_path}')
        end").runner.execute(:test)
      end

      it "prefers explicit parameters over environment variables" do
        mock_path = './assets/Test.xcarchive'

        allow(File).to receive(:exist?).with(mock_path).and_return(true)
        allow(File).to receive(:extname).with(mock_path).and_return('.xcarchive')

        # Set environment variables
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('SENTRY_HEAD_SHA').and_return('env_should_not_be_used')
        allow(ENV).to receive(:[]).with('SENTRY_BASE_SHA').and_return('env_should_not_be_used')

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          anything,
          ["build", "upload", anything, "--head-sha", "explicit_abc123", "--base-sha", "explicit_def456"]
        ).and_return(true)

        described_class.new.parse("lane :test do
          sentry_upload_build(
            auth_token: 'test-token',
            org_slug: 'test-org',
            project_slug: 'test-project',
            xcarchive_path: '#{mock_path}',
            head_sha: 'explicit_abc123',
            base_sha: 'explicit_def456')
        end").runner.execute(:test)
      end

      it "uses mixed explicit parameters and environment variables" do
        mock_path = './assets/Test.xcarchive'

        allow(File).to receive(:exist?).with(mock_path).and_return(true)
        allow(File).to receive(:extname).with(mock_path).and_return('.xcarchive')

        # Set some environment variables
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('SENTRY_VCS_PROVIDER').and_return('env_github')
        allow(ENV).to receive(:[]).with('SENTRY_PR_NUMBER').and_return('env_789')

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          anything,
          ["build", "upload", anything, "--head-sha", "explicit_abc123", "--vcs-provider", "env_github", "--pr-number", "env_789"]
        ).and_return(true)

        described_class.new.parse("lane :test do
          sentry_upload_build(
            auth_token: 'test-token',
            org_slug: 'test-org',
            project_slug: 'test-project',
            xcarchive_path: '#{mock_path}',
            head_sha: 'explicit_abc123')
        end").runner.execute(:test)
      end

      it "includes --release-notes if present" do
        mock_path = './assets/Test.xcarchive'

        allow(File).to receive(:exist?).with(mock_path).and_return(true)
        allow(File).to receive(:extname).with(mock_path).and_return('.xcarchive')

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          anything,
          ["build", "upload", anything, "--release-notes", "Fixed bugs"]
        ).and_return(true)

        described_class.new.parse("lane :test do
          sentry_upload_build(
            auth_token: 'test-token',
            org_slug: 'test-org',
            project_slug: 'test-project',
            xcarchive_path: '#{mock_path}',
            release_notes: 'Fixed bugs')
        end").runner.execute(:test)
      end

      it "includes --force-git-metadata when true" do
        mock_path = './assets/Test.xcarchive'

        allow(File).to receive(:exist?).with(mock_path).and_return(true)
        allow(File).to receive(:extname).with(mock_path).and_return('.xcarchive')

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          anything,
          ["build", "upload", anything, "--force-git-metadata"]
        ).and_return(true)

        described_class.new.parse("lane :test do
          sentry_upload_build(
            auth_token: 'test-token',
            org_slug: 'test-org',
            project_slug: 'test-project',
            xcarchive_path: '#{mock_path}',
            force_git_metadata: true)
        end").runner.execute(:test)
      end

      it "includes --no-git-metadata when true" do
        mock_path = './assets/Test.xcarchive'

        allow(File).to receive(:exist?).with(mock_path).and_return(true)
        allow(File).to receive(:extname).with(mock_path).and_return('.xcarchive')

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          anything,
          ["build", "upload", anything, "--no-git-metadata"]
        ).and_return(true)

        described_class.new.parse("lane :test do
          sentry_upload_build(
            auth_token: 'test-token',
            org_slug: 'test-org',
            project_slug: 'test-project',
            xcarchive_path: '#{mock_path}',
            no_git_metadata: true)
        end").runner.execute(:test)
      end

      it "fails when no build path is provided" do
        # Clear the default value from lane context
        Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = nil

        # Stub file checks for empty/nil values
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with(nil).and_return(false)
        allow(File).to receive(:exist?).with("").and_return(false)
        allow(File).to receive(:extname).and_call_original
        allow(File).to receive(:extname).with(nil).and_return('')
        allow(File).to receive(:extname).with("").and_return('')

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)

        expect do
          described_class.new.parse("lane :test do
            sentry_upload_build(
              auth_token: 'test-token',
              org_slug: 'test-org',
              project_slug: 'test-project')
          end").runner.execute(:test)
        end.to raise_error("One of xcarchive_path, apk_path, aab_path, or ipa_path must be provided")
      end

      it "fails when multiple build paths are provided" do
        mock_xcarchive = './assets/Test.xcarchive'
        mock_apk = './assets/Test.apk'

        allow(File).to receive(:exist?).with(mock_xcarchive).and_return(true)
        allow(File).to receive(:exist?).with(mock_apk).and_return(true)
        allow(File).to receive(:extname).with(mock_xcarchive).and_return('.xcarchive')
        allow(File).to receive(:extname).with(mock_apk).and_return('.apk')

        expect do
          described_class.new.parse("lane :test do
            sentry_upload_build(
              auth_token: 'test-token',
              org_slug: 'test-org',
              project_slug: 'test-project',
              xcarchive_path: '#{mock_xcarchive}',
              apk_path: '#{mock_apk}')
          end").runner.execute(:test)
        end.to raise_error(/Unresolved conflict between options/)
      end

      describe "APK upload" do
        it "calls sentry-cli with APK path" do
          mock_apk_path = './assets/Test.apk'

          # Clear default value and stub file checks
          Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = nil
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(mock_apk_path).and_return(true)
          allow(File).to receive(:exist?).with(nil).and_return(false)
          allow(File).to receive(:extname).and_call_original
          allow(File).to receive(:extname).with(mock_apk_path).and_return('.apk')
          allow(File).to receive(:extname).with(nil).and_return('')

          expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
          expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
            anything,
            ["build", "upload", anything]
          ).and_return(true)

          described_class.new.parse("lane :test do
            sentry_upload_build(
              auth_token: 'test-token',
              org_slug: 'test-org',
              project_slug: 'test-project',
              apk_path: '#{mock_apk_path}')
          end").runner.execute(:test)
        end

        it "fails when APK path does not exist" do
          non_existent_path = './assets/NonExistent.apk'

          # Clear default value
          Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = nil
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(non_existent_path).and_return(false)
          allow(File).to receive(:exist?).with(nil).and_return(false)
          allow(File).to receive(:extname).and_call_original
          allow(File).to receive(:extname).with(nil).and_return('')

          expect do
            described_class.new.parse("lane :test do
              sentry_upload_build(
                auth_token: 'test-token',
                org_slug: 'test-org',
                project_slug: 'test-project',
                apk_path: '#{non_existent_path}')
            end").runner.execute(:test)
          end.to raise_error("Could not find APK at path '#{non_existent_path}'")
        end

        it "fails when file is not an APK" do
          invalid_apk_path = './assets/test.zip'

          # Clear default value
          Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = nil
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(invalid_apk_path).and_return(true)
          allow(File).to receive(:exist?).with(nil).and_return(false)
          allow(File).to receive(:extname).and_call_original
          allow(File).to receive(:extname).with(invalid_apk_path).and_return('.zip')
          allow(File).to receive(:extname).with(nil).and_return('')

          expect do
            described_class.new.parse("lane :test do
              sentry_upload_build(
                auth_token: 'test-token',
                org_slug: 'test-org',
                project_slug: 'test-project',
                apk_path: '#{invalid_apk_path}')
            end").runner.execute(:test)
          end.to raise_error("Path '#{invalid_apk_path}' is not an APK")
        end
      end

      describe "AAB upload" do
        it "calls sentry-cli with AAB path" do
          mock_aab_path = './assets/Test.aab'

          # Clear default value and stub file checks
          Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = nil
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(mock_aab_path).and_return(true)
          allow(File).to receive(:exist?).with(nil).and_return(false)
          allow(File).to receive(:extname).and_call_original
          allow(File).to receive(:extname).with(mock_aab_path).and_return('.aab')
          allow(File).to receive(:extname).with(nil).and_return('')

          expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
          expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
            anything,
            ["build", "upload", anything]
          ).and_return(true)

          described_class.new.parse("lane :test do
            sentry_upload_build(
              auth_token: 'test-token',
              org_slug: 'test-org',
              project_slug: 'test-project',
              aab_path: '#{mock_aab_path}')
          end").runner.execute(:test)
        end

        it "fails when AAB path does not exist" do
          non_existent_path = './assets/NonExistent.aab'

          # Clear default value
          Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = nil
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(non_existent_path).and_return(false)
          allow(File).to receive(:exist?).with(nil).and_return(false)
          allow(File).to receive(:extname).and_call_original
          allow(File).to receive(:extname).with(nil).and_return('')

          expect do
            described_class.new.parse("lane :test do
              sentry_upload_build(
                auth_token: 'test-token',
                org_slug: 'test-org',
                project_slug: 'test-project',
                aab_path: '#{non_existent_path}')
            end").runner.execute(:test)
          end.to raise_error("Could not find AAB at path '#{non_existent_path}'")
        end

        it "fails when file is not an AAB" do
          invalid_aab_path = './assets/test.zip'

          # Clear default value
          Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = nil
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(invalid_aab_path).and_return(true)
          allow(File).to receive(:exist?).with(nil).and_return(false)
          allow(File).to receive(:extname).and_call_original
          allow(File).to receive(:extname).with(invalid_aab_path).and_return('.zip')
          allow(File).to receive(:extname).with(nil).and_return('')

          expect do
            described_class.new.parse("lane :test do
              sentry_upload_build(
                auth_token: 'test-token',
                org_slug: 'test-org',
                project_slug: 'test-project',
                aab_path: '#{invalid_aab_path}')
            end").runner.execute(:test)
          end.to raise_error("Path '#{invalid_aab_path}' is not an AAB")
        end
      end

      describe "IPA upload" do
        it "calls sentry-cli with IPA path" do
          mock_ipa_path = './assets/Test.ipa'

          # Clear default value and stub file checks
          Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = nil
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(mock_ipa_path).and_return(true)
          allow(File).to receive(:exist?).with(nil).and_return(false)
          allow(File).to receive(:extname).and_call_original
          allow(File).to receive(:extname).with(mock_ipa_path).and_return('.ipa')
          allow(File).to receive(:extname).with(nil).and_return('')

          expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
          expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
            anything,
            ["build", "upload", anything]
          ).and_return(true)

          described_class.new.parse("lane :test do
            sentry_upload_build(
              auth_token: 'test-token',
              org_slug: 'test-org',
              project_slug: 'test-project',
              ipa_path: '#{mock_ipa_path}')
          end").runner.execute(:test)
        end

        it "fails when IPA path does not exist" do
          non_existent_path = './assets/NonExistent.ipa'

          # Clear default value
          Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = nil
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(non_existent_path).and_return(false)
          allow(File).to receive(:exist?).with(nil).and_return(false)
          allow(File).to receive(:extname).and_call_original
          allow(File).to receive(:extname).with(nil).and_return('')

          expect do
            described_class.new.parse("lane :test do
              sentry_upload_build(
                auth_token: 'test-token',
                org_slug: 'test-org',
                project_slug: 'test-project',
                ipa_path: '#{non_existent_path}')
            end").runner.execute(:test)
          end.to raise_error("Could not find IPA at path '#{non_existent_path}'")
        end

        it "fails when file is not an IPA" do
          invalid_ipa_path = './assets/test.zip'

          # Clear default value
          Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = nil
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(invalid_ipa_path).and_return(true)
          allow(File).to receive(:exist?).with(nil).and_return(false)
          allow(File).to receive(:extname).and_call_original
          allow(File).to receive(:extname).with(invalid_ipa_path).and_return('.zip')
          allow(File).to receive(:extname).with(nil).and_return('')

          expect do
            described_class.new.parse("lane :test do
              sentry_upload_build(
                auth_token: 'test-token',
                org_slug: 'test-org',
                project_slug: 'test-project',
                ipa_path: '#{invalid_ipa_path}')
            end").runner.execute(:test)
          end.to raise_error("Path '#{invalid_ipa_path}' is not an IPA")
        end
      end

      it "calls sentry-cli with git parameters when using APK" do
        mock_apk_path = './assets/Test.apk'

        # Clear default value and stub file checks
        Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::XCODEBUILD_ARCHIVE] = nil
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with(mock_apk_path).and_return(true)
        allow(File).to receive(:exist?).with(nil).and_return(false)
        allow(File).to receive(:extname).and_call_original
        allow(File).to receive(:extname).with(mock_apk_path).and_return('.apk')
        allow(File).to receive(:extname).with(nil).and_return('')

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          anything,
          ["build", "upload", anything, "--head-sha", "abc123", "--base-sha", "def456"]
        ).and_return(true)

        described_class.new.parse("lane :test do
          sentry_upload_build(
            auth_token: 'test-token',
            org_slug: 'test-org',
            project_slug: 'test-project',
            apk_path: '#{mock_apk_path}',
            head_sha: 'abc123',
            base_sha: 'def456')
        end").runner.execute(:test)
      end
    end
  end
end
