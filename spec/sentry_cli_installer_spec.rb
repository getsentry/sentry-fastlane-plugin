require 'digest'
require 'tmpdir'
require 'zlib'

describe Fastlane::Helper::SentryCliInstaller do
  def stub_host(mac: false, windows: false, linux: false, cpu: 'arm64')
    allow(OS).to receive_messages(mac?: mac, windows?: windows, linux?: linux, host_cpu: cpu, host_os: 'fixture-os')
  end

  describe "manifest" do
    it "pins the version from script/sentry-cli.properties" do
      properties = File.read(File.expand_path('../script/sentry-cli.properties', __dir__))
      expect(described_class.version).to eq(properties[/^version\s*=\s*(\S+)/, 1])
    end

    it "contains a SHA-256 checksum for every asset" do
      expect(described_class.manifest['assets']).not_to be_empty
      described_class.manifest['assets'].each_value do |checksum|
        expect(checksum).to match(/\A[0-9a-f]{64}\z/)
      end
    end
  end

  describe "asset_name" do
    it "macOS arm64" do
      stub_host(mac: true, cpu: 'arm64')
      expect(described_class.asset_name).to eq('sentry-darwin-arm64.gz')
    end

    it "macOS x86_64" do
      stub_host(mac: true, cpu: 'x86_64')
      expect(described_class.asset_name).to eq('sentry-darwin-x64.gz')
    end

    it "Linux aarch64" do
      stub_host(linux: true, cpu: 'aarch64')
      expect(described_class.asset_name).to eq('sentry-linux-arm64.gz')
    end

    it "Linux x86_64" do
      stub_host(linux: true, cpu: 'x86_64')
      expect(described_class.asset_name).to eq('sentry-linux-x64.gz')
    end

    it "Windows x64" do
      stub_host(windows: true, cpu: 'x64')
      expect(described_class.asset_name).to eq('sentry-windows-x64.exe.gz')
    end

    it "fails on unsupported architectures" do
      stub_host(linux: true, cpu: 'i686')
      expect { described_class.asset_name }.to raise_error(/does not provide a prebuilt binary for this host/)
    end

    it "fails on unsupported operating systems" do
      stub_host(cpu: 'x86_64')
      expect { described_class.asset_name }.to raise_error(/does not provide a prebuilt binary for this host/)
    end
  end

  describe "download_url" do
    it "points to the pinned GitHub release asset" do
      stub_host(mac: true, cpu: 'arm64')
      expect(described_class.download_url).to eq("https://github.com/getsentry/cli/releases/download/#{described_class.version}/sentry-darwin-arm64.gz")
    end
  end

  describe "cache_dir" do
    around do |example|
      original = ENV.to_h.slice(described_class::CACHE_DIR_ENV, 'XDG_CACHE_HOME')
      ENV.delete(described_class::CACHE_DIR_ENV)
      ENV.delete('XDG_CACHE_HOME')
      example.run
    ensure
      ENV.delete(described_class::CACHE_DIR_ENV)
      ENV.delete('XDG_CACHE_HOME')
      ENV.update(original)
    end

    it "defaults to ~/.cache" do
      allow(OS).to receive(:windows?).and_return(false)
      expect(described_class.cache_dir).to eq(File.join(Dir.home, '.cache', 'sentry-fastlane-plugin'))
    end

    it "honors XDG_CACHE_HOME" do
      allow(OS).to receive(:windows?).and_return(false)
      ENV['XDG_CACHE_HOME'] = '/xdg/cache'
      expect(described_class.cache_dir).to eq('/xdg/cache/sentry-fastlane-plugin')
    end

    it "can be overridden" do
      ENV[described_class::CACHE_DIR_ENV] = '/custom/cache'
      expect(described_class.cache_dir).to eq('/custom/cache')
    end

    it "places the executable in a version specific directory" do
      ENV[described_class::CACHE_DIR_ENV] = '/custom/cache'
      stub_host(mac: true, cpu: 'arm64')
      expect(described_class.executable_path).to eq("/custom/cache/sentry-cli/#{described_class.version}/sentry-darwin-arm64")
    end
  end

  describe "ensure_installed!" do
    let(:binary_content) { "#!/bin/sh\necho fixture sentry\n" }
    let(:archive_content) do
      io = StringIO.new
      Zlib::GzipWriter.wrap(io) { |gz| gz.write(binary_content) }
      io.string
    end

    around do |example|
      Dir.mktmpdir do |dir|
        original = ENV.fetch(described_class::CACHE_DIR_ENV, nil)
        ENV[described_class::CACHE_DIR_ENV] = dir
        example.run
      ensure
        if original.nil?
          ENV.delete(described_class::CACHE_DIR_ENV)
        else
          ENV[described_class::CACHE_DIR_ENV] = original
        end
      end
    end

    before do
      stub_host(mac: true, cpu: 'arm64')
    end

    def stub_manifest(checksum)
      manifest = JSON.parse(JSON.dump(described_class.manifest))
      manifest['assets']['sentry-darwin-arm64.gz'] = checksum
      allow(described_class).to receive(:manifest).and_return(manifest)
    end

    it "downloads, verifies and extracts the CLI" do
      stub_manifest(Digest::SHA256.hexdigest(archive_content))
      expect(described_class).to receive(:download).with(described_class.download_url, anything) do |_url, destination|
        File.binwrite(destination, archive_content)
      end

      path = described_class.ensure_installed!

      expect(path).to eq(described_class.executable_path)
      expect(File.executable?(path)).to be(true)
      expect(File.read(path)).to eq(binary_content)
      expect(Dir.children(File.dirname(path))).to contain_exactly(File.basename(path), "#{File.basename(path)}.lock")
    end

    it "does not download again when the CLI is already installed" do
      path = described_class.executable_path
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, binary_content)
      File.chmod(0755, path)
      expect(described_class).not_to receive(:download)

      expect(described_class.ensure_installed!).to eq(path)
    end

    it "fails and cleans up on checksum mismatch" do
      stub_manifest('0' * 64)
      expect(described_class).to receive(:download) do |_url, destination|
        File.binwrite(destination, archive_content)
      end

      expect { described_class.ensure_installed! }.to raise_error(/Checksum mismatch/)
      expect(File.exist?(described_class.executable_path)).to be(false)
      expect(Dir.children(File.dirname(described_class.executable_path))).to contain_exactly("#{File.basename(described_class.executable_path)}.lock")
    end
  end
end
