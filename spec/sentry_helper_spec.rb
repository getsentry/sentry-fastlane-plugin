describe Fastlane::Helper::SentryHelper do
  let(:pinned_version) { Fastlane::Helper::SentryCliInstaller.version }

  describe "call_sentry_cli" do
    it "uses cli path resolved by find_and_check_sentry_cli_path!" do
      sentry_cli_path = 'path'
      options = {}
      expect(described_class).to receive(:find_and_check_sentry_cli_path!).with(options).and_return(sentry_cli_path)
      expected_env = {
        'SENTRY_PIPELINE' => "sentry-fastlane-plugin/#{Fastlane::Sentry::VERSION}",
        'SENTRY_CLI_NO_UPDATE_CHECK' => '1'
      }
      expect(Open3).to receive(:popen3).with(expected_env, "#{sentry_cli_path} subcommand")

      described_class.call_sentry_cli(options, ["subcommand"])
    end
  end

  describe "find_and_check_sentry_cli_path!" do
    it "uses the managed Sentry CLI when no sentry_cli_path is given" do
      managed_path = '/cache/sentry-cli/sentry'
      expect(Fastlane::Helper::SentryCliInstaller).to receive(:ensure_installed!).and_return(managed_path)
      expect(described_class).to receive(:`).with("#{managed_path} --version").and_return("#{pinned_version}\n")

      expect(described_class.find_and_check_sentry_cli_path!({})).to eq(managed_path)
    end

    it "uses sentry_cli_path passed to check its version" do
      sentry_cli_path = '/usr/local/bin/sentry'
      expect(Fastlane::Helper::SentryCliInstaller).not_to receive(:ensure_installed!)
      expect(described_class).to receive(:`).with("#{sentry_cli_path} --version").and_return("#{pinned_version}\n")

      expect(described_class.find_and_check_sentry_cli_path!({ sentry_cli_path: sentry_cli_path })).to eq(sentry_cli_path)
    end

    it "accepts a newer Sentry CLI" do
      sentry_cli_path = 'sentry'
      expect(described_class).to receive(:`).with("#{sentry_cli_path} --version").and_return("999.0.0\n")

      expect(described_class.find_and_check_sentry_cli_path!({ sentry_cli_path: sentry_cli_path })).to eq(sentry_cli_path)
    end

    it "fails on an outdated Sentry CLI" do
      sentry_cli_path = 'sentry'
      expect(described_class).to receive(:`).with("#{sentry_cli_path} --version").and_return("0.0.1\n")

      expect do
        described_class.find_and_check_sentry_cli_path!({ sentry_cli_path: sentry_cli_path })
      end.to raise_error("Your Sentry CLI is outdated, please upgrade to at least version #{pinned_version} and start your lane again!")
    end

    it "fails on the legacy sentry-cli" do
      sentry_cli_path = '/usr/local/bin/sentry-cli'
      expect(described_class).to receive(:`).with("#{sentry_cli_path} --version").and_return("sentry-cli 3.8.0\n")

      expect do
        described_class.find_and_check_sentry_cli_path!({ sentry_cli_path: sentry_cli_path })
      end.to raise_error(/legacy sentry-cli, which is no longer supported/)
    end

    it "fails when the version cannot be determined" do
      sentry_cli_path = 'sentry'
      expect(described_class).to receive(:`).with("#{sentry_cli_path} --version").and_return("")

      expect do
        described_class.find_and_check_sentry_cli_path!({ sentry_cli_path: sentry_cli_path })
      end.to raise_error("Could not determine the version of the Sentry CLI at 'sentry'")
    end
  end
end
