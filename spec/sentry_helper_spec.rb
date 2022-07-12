describe Fastlane::Helper::SentryHelper do
  describe "call_sentry_cli" do
    it "uses cli path resolved by find_and_check_sentry_cli_path!" do
      sentry_cli_path = 'path'
      options = {}
      expect(Fastlane::Helper::SentryHelper).to receive(:find_and_check_sentry_cli_path!).with(options).and_return(sentry_cli_path)
      expect(Open3).to receive(:popen2e).with("#{sentry_cli_path} subcommand")

      Fastlane::Helper::SentryHelper.call_sentry_cli(options, ["subcommand"])
    end
  end

  describe "find_and_check_sentry_cli_path!" do
    it "uses sentry_cli_path passed to check its version" do
      bundled_sentry_cli_path = `bundle exec sentry_cli_path`
      bundled_sentry_cli_version = `#{bundled_sentry_cli_path} --version`

      sentry_cli_path = 'path'
      expect(described_class).to receive(:`).with("bundle exec sentry_cli_path").and_return(bundled_sentry_cli_path) # Called in test
      expect(described_class).to receive(:`).with("#{bundled_sentry_cli_path} --version").and_return(bundled_sentry_cli_path) # Called for bundled version
      expect(described_class).to receive(:`).with("#{sentry_cli_path} --version").and_return(bundled_sentry_cli_version) # Called sentry_cli_path parmeter 

      expect(Fastlane::Helper::SentryHelper.find_and_check_sentry_cli_path!({ sentry_cli_path: sentry_cli_path })).to eq(sentry_cli_path)
    end
  end
end
