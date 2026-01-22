describe Fastlane::Helper::SentryConfig do
  describe "fallback .sentryclirc" do
    it "auth failing calling sentry-cli info" do
      expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["info", "--config-status-json"]).and_return("{\"auth\":{\"type\":null,\"successful\":false}}")
      expect(described_class.fallback_sentry_cli_auth({})).to be_falsey
    end
  end

  describe "parse_api_params" do
    it "does not set env if no value" do
      described_class.parse_api_params({ auth_token: 'fixture-auth-token' })
      expect(ENV.fetch('SENTRY_LOG_LEVEL', nil)).to be_nil
    end

    it "sets debug env if Fastlane is set to verbose" do
      FastlaneCore::Globals.verbose = true
      described_class.parse_api_params({ auth_token: 'fixture-auth-token' })
      expect(ENV.fetch('SENTRY_LOG_LEVEL', nil)).to eq('debug')
    end

    it "sets trace env" do
      described_class.parse_api_params({ auth_token: 'fixture-auth-token', log_level: 'trace' })
      expect(ENV.fetch('SENTRY_LOG_LEVEL', nil)).to eq('trace')
    end

    it "sets debug env" do
      described_class.parse_api_params({ auth_token: 'fixture-auth-token', log_level: 'debug' })
      expect(ENV.fetch('SENTRY_LOG_LEVEL', nil)).to eq('debug')
    end

    it "sets info env" do
      described_class.parse_api_params({ auth_token: 'fixture-auth-token', log_level: 'info' })
      expect(ENV.fetch('SENTRY_LOG_LEVEL', nil)).to eq('info')
    end

    it "sets warn env" do
      described_class.parse_api_params({ auth_token: 'fixture-auth-token', log_level: 'warn' })
      expect(ENV.fetch('SENTRY_LOG_LEVEL', nil)).to eq('warn')
    end

    it "sets error env" do
      described_class.parse_api_params({ auth_token: 'fixture-auth-token', log_level: 'error' })
      expect(ENV.fetch('SENTRY_LOG_LEVEL', nil)).to eq('error')
    end

    it "raise error on invalid log_level" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          sentry_debug_files_upload(
            auth_token: 'fixture-auth-token',
            path: 'fixture-path',
            log_level: 'unknown'
          )
        end").runner.execute(:test)
      end.to raise_error("Invalid log level 'unknown'")
    end
  end
end
