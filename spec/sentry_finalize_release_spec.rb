describe Fastlane do
  describe Fastlane::FastFile do
    describe "finalize release" do
      it "accepts app_identifier" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "finalize", "app.idf@1.0"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_finalize_release(
              version: '1.0',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "accepts build" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "finalize", "1.0+123"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_finalize_release(
              version: '1.0',
              build: '123')
        end").runner.execute(:test)
      end

      it "does not prepend app_identifier if not specified" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "finalize", "1.0"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_finalize_release(
              version: '1.0')
        end").runner.execute(:test)
      end

      it "includes --url if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "finalize", "1.0", "--url", "https://example.com/release"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_finalize_release(
              version: '1.0',
              release_url: 'https://example.com/release')
        end").runner.execute(:test)
      end

      it "includes --released if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "finalize", "1.0", "--released", "1234567890"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_finalize_release(
              version: '1.0',
              released: '1234567890')
        end").runner.execute(:test)
      end
    end
  end
end
