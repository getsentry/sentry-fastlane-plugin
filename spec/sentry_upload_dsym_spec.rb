describe Fastlane do
  describe Fastlane::FastFile do
    describe "sentry" do
      before(:each) do
        #result = Fastlane::FastFile.new.parse("lane :test do
        #  gym()
        #end").runner.execute(:test)
      end

  
      it "fails with no API key or auth token" do
        dsym_path_1 = './fastlane/spec/fixtures/dSYM/Themoji.dSYM.zip'

        expect do
          result = Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dsym(
              org_slug: 'some_org',
              project_slug: 'some_project',
              dsym_path: '#{dsym_path_1}')
          end").runner.execute(:test)
        end.to raise_error("No API key or authentication token found for SentryAction given, pass using `api_key: 'key'` or `auth_token: 'token'`")
      end

      it "fails with API key and auth token" do
        dsym_path_1 = './fastlane/spec/fixtures/dSYM/Themoji.dSYM.zip'

        expect do
          result = Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dsym(
              org_slug: 'some_org',
              api_key: 'something123',
              auth_token: 'something123',
              project_slug: 'some_project',
              dsym_path: '#{dsym_path_1}')
          end").runner.execute(:test)
        end.to raise_error("Both API key and authentication token found for SentryAction given, please only give one")
      end

      it "returns uploaded dSYM path using API key" do
        dsym_path_1 = './fastlane/spec/fixtures/dSYM/Themoji.dSYM.zip'

        result = Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dsym(
            api_key: 'something123',
            org_slug: 'some_org',
            project_slug: 'some_project',
            dsym_path: '#{dsym_path_1}')
        end").runner.execute(:test)

        expect(result).to include(dsym_path_1)
      end

      it "returns uploaded dSYM path using auth token" do
        dsym_path_1 = './fastlane/spec/fixtures/dSYM/Themoji.dSYM.zip'

        result = Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dsym(
            auth_token: 'something123',
            org_slug: 'some_org',
            project_slug: 'some_project',
            dsym_path: '#{dsym_path_1}')
        end").runner.execute(:test)

        expect(result).to include(dsym_path_1)
      end

      it "returns uploaded dSYM paths" do
        dsym_path_1 = './fastlane/spec/fixtures/dSYM/Themoji.dSYM.zip'
        dsym_path_2 = './fastlane/spec/fixtures/dSYM/This_doesnt_exist_but_doesnt_need_to.dSYM.zip'

        result = Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dsym(
            api_key: 'something123',
            org_slug: 'some_org',
            project_slug: 'some_project',
            dsym_path: '#{dsym_path_1}',
            dsym_paths: ['#{dsym_path_2}'])
        end").runner.execute(:test)

        expect(result).to include(dsym_path_1)
        expect(result).to include(dsym_path_2)
      end
    end
  end
end
