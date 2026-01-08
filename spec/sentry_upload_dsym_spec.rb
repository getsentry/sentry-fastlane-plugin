describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload dsym" do
      it "fails without auth token" do
        dsym_path_1 = File.absolute_path './assets/SwiftExample.app.dSYM.zip'
        
        # Mock parse_api_params to raise the auth error directly
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_raise("No authentication token found for SentryAction given, pass using `auth_token: 'token'`")

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dsym(
              org_slug: 'some_org',
              project_slug: 'some_project',
              dsym_path: '#{dsym_path_1}')
          end").runner.execute(:test)
        end.to raise_error("No authentication token found for SentryAction given, pass using `auth_token: 'token'`")
      end

      it "fails with invalid dsym path" do
        dsym_path_1 = File.absolute_path './assets/this_does_not_exist.app.dSYM.zip'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dsym(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              dsym_path: '#{dsym_path_1}')
          end").runner.execute(:test)
        end.to raise_error("Could not find Path to your symbols file at path '#{dsym_path_1}'")
      end

      it "should add bcsymbols to sentry-cli call" do
        dsym_path_1 = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.bcsymbol").and_return(true)

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["upload-dsym", "--symbol-maps", "1.bcsymbol", dsym_path_1]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dsym(
            org_slug: 'some_org',
            auth_token: 'something123',
            project_slug: 'some_project',
            symbol_maps: '1.bcsymbol',
            dsym_path: '#{dsym_path_1}')
        end").runner.execute(:test)
      end

      it "multiple dsym paths" do
        dsym_path_1 = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["upload-dsym", dsym_path_1, dsym_path_1]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dsym(
            org_slug: 'some_org',
            auth_token: 'something123',
            project_slug: 'some_project',
            dsym_paths: ['#{dsym_path_1}', '#{dsym_path_1}'])
        end").runner.execute(:test)
      end

      it "Info.plist should exist" do
        dsym_path_1 = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("Info.plist").and_return(true)

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["upload-dsym", "--info-plist", "Info.plist", dsym_path_1]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dsym(
            org_slug: 'some_org',
            auth_token: 'something123',
            project_slug: 'some_project',
            dsym_paths: ['#{dsym_path_1}'],
            info_plist: 'Info.plist')
        end").runner.execute(:test)
      end
    end
  end
end
