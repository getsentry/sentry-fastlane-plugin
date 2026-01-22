describe Fastlane::Helper::SentryHelper do
  describe "call_sentry_cli" do
    it "uses cli path resolved by find_and_check_sentry_cli_path!" do
      sentry_cli_path = 'path'
      options = {}
      expect(described_class).to receive(:find_and_check_sentry_cli_path!).with(options).and_return(sentry_cli_path)
      expect(Open3).to receive(:popen3).with({ 'SENTRY_PIPELINE' => "sentry-fastlane-plugin/#{Fastlane::Sentry::VERSION}" }, "#{sentry_cli_path} subcommand")

      described_class.call_sentry_cli(options, ["subcommand"])
    end
  end

  describe "find_and_check_sentry_cli_path!" do
    it "uses sentry_cli_path passed to check its version" do
      bundled_sentry_cli_path = described_class.bundled_sentry_cli_path
      bundled_sentry_cli_version = `#{bundled_sentry_cli_path} --version`

      sentry_cli_path = 'path'

      expect(described_class).to receive(:`).with("#{bundled_sentry_cli_path} --version").and_return(bundled_sentry_cli_path) # Called for bundled version
      expect(described_class).to receive(:`).with("#{sentry_cli_path} --version").and_return(bundled_sentry_cli_version) # Called sentry_cli_path parmeter

      expect(described_class.find_and_check_sentry_cli_path!({ sentry_cli_path: sentry_cli_path })).to eq(sentry_cli_path)
    end
  end

  describe "bundled_sentry_cli_path" do
    it "mac universal" do
      expect(OS).to receive(:mac?).and_return(true)

      expexted_file_path = File.expand_path('../bin/sentry-cli-Darwin-universal', File.dirname(__FILE__))
      expect(described_class.bundled_sentry_cli_path).to eq(expexted_file_path)
    end

    it "windows 64 bit" do
      expect(OS).to receive(:mac?).and_return(false)
      expect(OS).to receive(:windows?).and_return(true)
      expect(OS).to receive(:bits).and_return(64)

      expexted_file_path = File.expand_path('../bin/sentry-cli-Windows-x86_64.exe', File.dirname(__FILE__))
      expect(described_class.bundled_sentry_cli_path).to eq(expexted_file_path)
    end

    it "windows 32 bit" do
      expect(OS).to receive(:mac?).and_return(false)
      expect(OS).to receive(:windows?).and_return(true)
      expect(OS).to receive(:bits).and_return(32)

      expexted_file_path = File.expand_path('../bin/sentry-cli-Windows-i686.exe', File.dirname(__FILE__))
      expect(described_class.bundled_sentry_cli_path).to eq(expexted_file_path)
    end

    it "linux 64 bit" do
      expect(OS).to receive(:mac?).and_return(false)
      expect(OS).to receive(:windows?).and_return(false)
      expect(OS).to receive(:bits).and_return(64)

      expexted_file_path = File.expand_path('../bin/sentry-cli-Linux-x86_64', File.dirname(__FILE__))
      expect(described_class.bundled_sentry_cli_path).to eq(expexted_file_path)
    end

    it "linux 32 bit" do
      expect(OS).to receive(:mac?).and_return(false)
      expect(OS).to receive(:windows?).and_return(false)
      expect(OS).to receive(:bits).and_return(32)

      expexted_file_path = File.expand_path('../bin/sentry-cli-Linux-i686', File.dirname(__FILE__))
      expect(described_class.bundled_sentry_cli_path).to eq(expexted_file_path)
    end
  end
end
