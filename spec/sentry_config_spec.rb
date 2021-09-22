describe Fastlane::Helper::SentryConfig do
  describe "fallback .sentryclirc" do
    it "auth failing calling sentry-cli info" do
      expect(Fastlane::Helper::SentryConfig.fallback_sentry_cli_auth).to be_falsey
    end
  end
end
