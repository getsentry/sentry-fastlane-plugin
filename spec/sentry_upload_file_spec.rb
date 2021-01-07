describe Fastlane do
  describe Fastlane::FastFile do
    describe "sentry" do
      it "fails with invalid file path" do
        file_path = File.absolute_path './assets/this_does_not_exist.js'
        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_file(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              file: '#{file_path}')
          end").runner.execute(:test)
        end.to raise_error("Could not find file at path '#{file_path}'")
      end

      it "does not require dist to be specified" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "releases", "files", "app.idf@1.0", "upload", "demo.file"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("demo.file").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_file(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              file: 'demo.file',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "accepts app_identifier" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "releases", "files", "app.idf@1.0", "upload", "demo.file", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("demo.file").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_file(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              file: 'demo.file',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "does not prepend app_identifier if not specified" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "releases", "files", "1.0", "upload", "demo.file", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("demo.file").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_file(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              file: 'demo.file')
        end").runner.execute(:test)
      end
    end
  end
end
