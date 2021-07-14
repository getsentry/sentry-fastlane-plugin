describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload-dif" do
      it "includes --path if present" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths'
            )
        end").runner.execute(:test)
      end
    end
  end
end
