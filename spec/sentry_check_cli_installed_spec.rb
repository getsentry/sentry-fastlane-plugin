describe Fastlane do
  describe Fastlane::FastFile do
    describe "check cli installed" do
      it "success when find_and_check_sentry_cli_path passes" do
        expect(Fastlane::Helper::SentryHelper).to receive(:find_and_check_sentry_cli_path!).and_return('path')

        Fastlane::FastFile.new.parse("lane :test do
          sentry_check_cli_installed()
        end").runner.execute(:test)
      end

      it "raise error on invalid sentry_cli_path" do
        path = 'invalid_cli_path'
        expect(FastlaneCore::Helper).to receive(:executable?).and_return(false)
        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_check_cli_installed(
              sentry_cli_path: '#{path}'
            )
          end").runner.execute(:test)
        end.to raise_error("'#{path}' is not executable")
      end
    end
  end
end
