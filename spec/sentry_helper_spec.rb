describe Fastlane::Helper::SentryHelper do
  describe "call_sentry_cli" do
    it "uses cli detected by check_sentry_cli!" do
      options = {
        sentry_cli_path: 'path'
      }
      expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).with(options).and_return('sentry-cli')
      expect(Open3).to receive(:popen3).with("sentry-cli subcommand")
      Fastlane::Helper::SentryHelper.call_sentry_cli(options, ["subcommand"])
    end
  end

  describe "check_sentry_cli!" do
    it "uses cli path passed" do
      expect(described_class).to receive(:`).with('path --version').and_return(Fastlane::Sentry::CLI_VERSION)
      expect(Fastlane::Helper::SentryHelper.check_sentry_cli!({sentry_cli_path: 'path'})).to eq('path')
    end
  end
end
