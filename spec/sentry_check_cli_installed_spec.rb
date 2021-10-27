describe Fastlane do
  describe Fastlane::FastFile do
    describe "check cli installed" do
      it "success when find_and_check_sentry_cli_path passes" do
        expect(Fastlane::Helper::SentryHelper).to receive(:find_and_check_sentry_cli_path!).and_return('path')

        Fastlane::FastFile.new.parse("lane :test do
            sentry_check_cli_installed()
        end").runner.execute(:test)
      end
    end
  end
end
