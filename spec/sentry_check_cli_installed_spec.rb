describe Fastlane do
  describe Fastlane::FastFile do
    describe "check cli installed" do
      it "success when check_sentry_cli true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_check_cli_installed()
        end").runner.execute(:test)
      end
    end
  end
end
