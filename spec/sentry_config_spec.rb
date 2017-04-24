describe Fastlane::Helper::SentryConfig do
  describe "parse_api_params" do
    it "fails with no API key or auth token" do
      expect do
        Fastlane::Helper::SentryConfig.parse_api_params({})
      end.to raise_error("No API key or authentication token found for SentryAction given, pass using `api_key: 'key'` or `auth_token: 'token'`")
    end

    it "fails with API key and auth token" do
      expect do
        Fastlane::Helper::SentryConfig.parse_api_params({
          api_key: 'something123',
          auth_token: 'something123'
        })
      end.to raise_error("Both API key and authentication token found for SentryAction given, please only give one")
    end
  end
end
