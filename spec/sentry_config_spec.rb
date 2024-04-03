describe Fastlane::Helper::SentryConfig do
  describe "fallback .sentryclirc" do
    it "auth failing calling sentry-cli info" do
      expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["info", "--config-status-json"]).and_return("{\"auth\":{\"type\":null,\"successful\":false}}")
      expect(Fastlane::Helper::SentryConfig.fallback_sentry_cli_auth({})).to be_falsey
    end
  end

  describe "parse_api_params" do
    it "does not set env if no value" do
      Fastlane::Helper::SentryConfig.parse_api_params({})
      expect(ENV['SENTRY_LOG_LEVEL']).to be_nil
    end

    it "sets debug env if Fastlane is set to verbose" do
      FastlaneCore::Globals.verbose = true
      Fastlane::Helper::SentryConfig.parse_api_params({})
      expect(ENV['SENTRY_LOG_LEVEL']).to eq('debug')
    end

    it "sets trace env" do
      Fastlane::Helper::SentryConfig.parse_api_params({ log_level: 'trace' })
      expect(ENV['SENTRY_LOG_LEVEL']).to eq('trace')
    end

    it "sets debug env" do
      Fastlane::Helper::SentryConfig.parse_api_params({ log_level: 'debug' })
      expect(ENV['SENTRY_LOG_LEVEL']).to eq('debug')
    end

    it "sets info env" do
      Fastlane::Helper::SentryConfig.parse_api_params({ log_level: 'info' })
      expect(ENV['SENTRY_LOG_LEVEL']).to eq('info')
    end

    it "sets warn env" do
      Fastlane::Helper::SentryConfig.parse_api_params({ log_level: 'warn' })
      expect(ENV['SENTRY_LOG_LEVEL']).to eq('warn')
    end

    it "sets error env" do
      Fastlane::Helper::SentryConfig.parse_api_params({ log_level: 'error' })
      expect(ENV['SENTRY_LOG_LEVEL']).to eq('error')
    end

    it "raise error on invalid log_level" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          sentry_debug_files_upload(
            log_level: 'unknown'
          )
        end").runner.execute(:test)
      end.to raise_error("Invalid log level 'unknown'")
    end
  end
end
