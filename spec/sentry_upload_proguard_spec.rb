describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload proguard" do
      it "fails with API key and auth token" do
        mapping_path = File.absolute_path './assets/AndroidExample.mapping.txt'
        android_manifest_path = File.absolute_path './assets/AndroidManifest.xml'
        
        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              api_key: 'something123',
              auth_token: 'something123',
              project_slug: 'some_project',
              mapping_path: '#{mapping_path}',
              android_manifest_path: '#{android_manifest_path}')
          end").runner.execute(:test)
        end.to raise_error("Both API key and authentication token found for SentryAction given, please only give one")
      end

      it "fails with invalid mapping path" do
        mapping_path = File.absolute_path './assets/this.does.not.exist.mapping.txt'
        android_manifest_path = File.absolute_path './assets/AndroidManifest.xml'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              mapping_path: '#{mapping_path}',
              android_manifest_path: '#{android_manifest_path}')
          end").runner.execute(:test)
        end.to raise_error("Could not find your mapping file at path '#{mapping_path}'")
      end

      it "fails with invalid android manifest path" do
        mapping_path = File.absolute_path './assets/AndroidExample.mapping.txt'
        android_manifest_path = File.absolute_path './assets/this.does.not.exist.xml'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              mapping_path: '#{mapping_path}',
              android_manifest_path: '#{android_manifest_path}')
          end").runner.execute(:test)
        end.to raise_error("Could not find your merged AndroidManifest file at path '#{android_manifest_path}'")
      end

      it "accepts valid android manifest path and missing mapping uuid" do
        mapping_path = File.absolute_path './assets/AndroidExample.mapping.txt'
        android_manifest_path = File.absolute_path './assets/AndroidManifest.xml'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          ["sentry-cli", "upload-proguard", "--android-manifest", android_manifest_path, mapping_path]
        ).and_return(true)

        allow(File).to receive(:exist?).and_call_original

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              mapping_path: '#{mapping_path}',
              android_manifest_path: '#{android_manifest_path}')
        end").runner.execute(:test)
      end

      it "accepts valid mapping uuid and app id" do
        mapping_path = File.absolute_path './assets/AndroidExample.mapping.txt'
        mapping_uuid = "c96e0f5a-8dc5-11eb-8dcd-0242ac130003"
        android_app_id = "com.example.app.id"

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          ["sentry-cli", "upload-proguard", "--app-id", android_app_id, "--uuid", mapping_uuid, mapping_path]
        ).and_return(true)

        allow(File).to receive(:exist?).and_call_original

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              app_id: '#{android_app_id}',
              uuid: '#{mapping_uuid}',
              mapping_path: '#{mapping_path}')
        end").runner.execute(:test)
      end

      it "accepts false flags" do
        mapping_path = File.absolute_path './assets/AndroidExample.mapping.txt'
        android_manifest_path = File.absolute_path './assets/AndroidManifest.xml'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          ["sentry-cli", "upload-proguard", "--android-manifest", android_manifest_path, mapping_path]
        ).and_return(true)

        allow(File).to receive(:exist?).and_call_original

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              android_manifest_path: '#{android_manifest_path}',
              no_reprocessing: false,
              no_upload: false,
              require_one: false,
              mapping_path: '#{mapping_path}')
        end").runner.execute(:test)
      end

      it "accepts all supported cli parameters" do
        mapping_path = File.absolute_path './assets/AndroidExample.mapping.txt'
        android_manifest_path = File.absolute_path './assets/AndroidManifest.xml'
        mapping_uuid = "c96e0f5a-8dc5-11eb-8dcd-0242ac130003"
        android_app_id = "com.example.app.id"
        platform = "fushia"
        version_name = "1.2.3-test"
        version_code = 45

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(
          [
            "sentry-cli", "upload-proguard", "--android-manifest", android_manifest_path, "--app-id", android_app_id,
            "--no-reprocessing", "--no-upload", "--platform", platform, "--require-one", "--uuid", mapping_uuid,
            "--version", version_name, "--version-code", version_code, mapping_path
          ]
        ).and_return(true)

        allow(File).to receive(:exist?).and_call_original

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              android_manifest_path: '#{android_manifest_path}',
              app_id: '#{android_app_id}',
              no_reprocessing: true,
              no_upload: true,
              platform: '#{platform}',
              require_one: true,
              uuid: '#{mapping_uuid}',
              version: '#{version_name}',
              version_code: #{version_code},
              mapping_path: '#{mapping_path}')
        end").runner.execute(:test)
      end
    end
  end
end
