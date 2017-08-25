describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload dsym" do
      it "fails with no API key or auth token" do
        dsym_path_1 = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dsym(
              org_slug: 'some_org',
              project_slug: 'some_project',
              dsym_path: '#{dsym_path_1}')
          end").runner.execute(:test)
        end.to raise_error("No API key or authentication token found for SentryAction given, pass using `api_key: 'key'` or `auth_token: 'token'`")
      end

      it "fails with API key and auth token" do
        dsym_path_1 = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dsym(
              org_slug: 'some_org',
              api_key: 'something123',
              auth_token: 'something123',
              project_slug: 'some_project',
              dsym_path: '#{dsym_path_1}')
          end").runner.execute(:test)
        end.to raise_error("Both API key and authentication token found for SentryAction given, please only give one")
      end

      it "fails with invalid dsym path" do
        dsym_path_1 = File.absolute_path './assets/this_does_not_exist.app.dSYM.zip'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dsym(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              dsym_path: '#{dsym_path_1}')
          end").runner.execute(:test)
        end.to raise_error("Could not find Path to your symbols file at path '#{dsym_path_1}'")
      end

      it "should add bcsymbols to sentry-cli call" do
        dsym_path_1 = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.bcsymbol").and_return(true)

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dsym", "--symbol-maps", "1.bcsymbol", dsym_path_1]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dsym(
            org_slug: 'some_org',
            api_key: 'something123',
            project_slug: 'some_project',
            symbol_maps: '1.bcsymbol',
            dsym_path: '#{dsym_path_1}')
        end").runner.execute(:test)

      end
    end
  end
end
