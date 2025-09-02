module Fastlane
  module Actions
    def self.lane_context
      @lane_context ||= {}
    end
  end

  module SharedValues
    XCODEBUILD_ARCHIVE ||= :xcodebuild_archive
  end
end

describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload mobile app" do
      # We'll use the dSYM file as a mock xcarchive for testing since we need an existing file
      let(:mock_xcarchive_path) { File.absolute_path './assets/SwiftExample.app.dSYM.zip' }

      it "fails when xcarchive path does not exist" do
        non_existent_path = './assets/NonExistent.xcarchive'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_mobile_app(
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
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_mobile_app(
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

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_mobile_app(
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

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_mobile_app(
            auth_token: 'test-token',
            org_slug: 'test-org',
            project_slug: 'test-project')
        end").runner.execute(:test)
      end
    end
  end
end
