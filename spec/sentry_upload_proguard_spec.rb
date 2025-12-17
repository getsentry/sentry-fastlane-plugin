describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload proguard" do
      it "fails with API key and auth token" do
        mapping_path = File.absolute_path './assets/AndroidExample.mapping.txt'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              api_key: 'something123',
              auth_token: 'something123',
              project_slug: 'some_project',
              mapping_path: '#{mapping_path}')
          end").runner.execute(:test)
        end.to raise_error("Both API key and authentication token found for SentryAction given, please only give one")
      end

      it "fails with invalid mapping path" do
        mapping_path = File.absolute_path './assets/this.does.not.exist.mapping.txt'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_proguard(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              mapping_path: '#{mapping_path}')
          end").runner.execute(:test)
        end.to raise_error("Could not find your mapping file at path '#{mapping_path}'")
      end
    end
  end
end
