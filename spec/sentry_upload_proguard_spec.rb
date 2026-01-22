describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload proguard" do
      it "fails with invalid mapping path" do
        mapping_path = File.absolute_path './assets/this.does.not.exist.mapping.txt'

        expect do
          described_class.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              mapping_path: '#{mapping_path}')
          end").runner.execute(:test)
        end.to raise_error("Could not find your mapping file at path '#{mapping_path}'")
      end

      it "includes --no-upload when true" do
        mapping_path = File.absolute_path './assets/AndroidExample.mapping.txt'
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["upload-proguard", mapping_path, "--no-upload"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              mapping_path: '#{mapping_path}',
              no_upload: true)
        end").runner.execute(:test)
      end

      it "includes --write-properties if present" do
        mapping_path = File.absolute_path './assets/AndroidExample.mapping.txt'
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["upload-proguard", mapping_path, "--write-properties", "path/to/properties"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              mapping_path: '#{mapping_path}',
              write_properties: 'path/to/properties')
        end").runner.execute(:test)
      end

      it "includes --require-one when true" do
        mapping_path = File.absolute_path './assets/AndroidExample.mapping.txt'
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["upload-proguard", mapping_path, "--require-one"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              mapping_path: '#{mapping_path}',
              require_one: true)
        end").runner.execute(:test)
      end

      it "includes --uuid if present" do
        mapping_path = File.absolute_path './assets/AndroidExample.mapping.txt'
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["upload-proguard", mapping_path, "--uuid", "custom-uuid"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              mapping_path: '#{mapping_path}',
              uuid: 'custom-uuid')
        end").runner.execute(:test)
      end
    end
  end
end
