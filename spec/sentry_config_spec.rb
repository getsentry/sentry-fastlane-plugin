describe Fastlane::Helper::SentryConfig do
  describe "fallback .sentryclirc" do
    it "auth failing calling sentry-cli info" do
      expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["info", "--config-status-json"]).and_return("{\"auth\":{\"type\":null,\"successful\":false}}")
      expect(Fastlane::Helper::SentryConfig.fallback_sentry_cli_auth({})).to be_falsey
    end
  end
end
