describe Fastlane do
  describe Fastlane::FastFile do
    describe "create release" do
      it "accepts app_identifier" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with("sentry-cli releases new 'app.idf-1.0' ").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_release(
              version: '1.0',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end
    end
  end
end
