describe Fastlane do
  describe Fastlane::FastFile do
    describe "set commits" do
      it "accepts app_identifier" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "app.idf@1.0"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "accepts build" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0+123"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0',
              build: '123')
        end").runner.execute(:test)
      end

      it "does not prepend app_identifier if not specified" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0')
        end").runner.execute(:test)
      end

      it "includes --auto when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0", "--auto"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0',
              auto: true)
        end").runner.execute(:test)
      end

      it "omits --auto when not present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0"]).and_return(true)
        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0')
        end").runner.execute(:test)
      end

      it "omits --auto when false" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0"]).and_return(true)
        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0',
              auto: false)
        end").runner.execute(:test)
      end

      it "includes --clear when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0", "--clear"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0',
              clear: true)
        end").runner.execute(:test)
      end

      it "omits --clear when not present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0"]).and_return(true)
        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0')
        end").runner.execute(:test)
      end

      it "omits --clear when false" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0"]).and_return(true)
        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0',
              clear: false)
        end").runner.execute(:test)
      end

      it "includes --commit when given" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0", "--commit", "abc"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0',
              commit: 'abc')
        end").runner.execute(:test)
      end

      it "omits --commit when not not given" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0"]).and_return(true)
        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0')
        end").runner.execute(:test)
      end

      it "includes --ignore-missing when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0", "--ignore-missing"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0',
              ignore_missing: true)
        end").runner.execute(:test)
      end

      it "omits --ignore-missing when not present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0"]).and_return(true)
        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0')
        end").runner.execute(:test)
      end

      it "omits --ignore-missing when false" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "set-commits", "1.0"]).and_return(true)
        Fastlane::FastFile.new.parse("lane :test do
            sentry_set_commits(
              version: '1.0',
              ignore_missing: false)
        end").runner.execute(:test)
      end
    end
  end
end
