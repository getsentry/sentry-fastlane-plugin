describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload dif" do
      
      it "fails with API key and auth token" do
        dif_path_1 = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              org_slug: 'some_org',
              api_key: 'something123',
              auth_token: 'something123',
              project_slug: 'some_project',
              dif_path: '#{dif_path_1}')
          end").runner.execute(:test)
        end.to raise_error("Both API key and authentication token found for SentryAction given, please only give one")
      end

      it "fails with invalid dif path" do
        dif_path_1 = File.absolute_path './assets/this_does_not_exist.app.dSYM.zip'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              dif_path: '#{dif_path_1}')
          end").runner.execute(:test)
        end.to raise_error("Could not find Path to your symbols file at path '#{dif_path_1}'")
      end

      it "should add bcsymbols to sentry-cli call" do
        dif_path_1 = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.bcsymbol").and_return(true)

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--symbol-maps", "1.bcsymbol", dif_path_1]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dif(
            org_slug: 'some_org',
            api_key: 'something123',
            project_slug: 'some_project',
            symbol_maps: '1.bcsymbol',
            dif_path: '#{dif_path_1}')
        end").runner.execute(:test)
      end

      it "multiple dif paths" do
        dif_path_1 = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", dif_path_1, dif_path_1]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dif(
            org_slug: 'some_org',
            api_key: 'something123',
            project_slug: 'some_project',
            dif_paths: ['#{dif_path_1}', '#{dif_path_1}'])
        end").runner.execute(:test)
      end

      it "Info.plist should exist" do
        dif_path_1 = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("Info.plist").and_return(true)

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--info-plist", "Info.plist", dif_path_1]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dif(
            org_slug: 'some_org',
            api_key: 'something123',
            project_slug: 'some_project',
            dif_paths: ['#{dif_path_1}'],
            info_plist: 'Info.plist')
        end").runner.execute(:test)
      end
    end
  end
end
