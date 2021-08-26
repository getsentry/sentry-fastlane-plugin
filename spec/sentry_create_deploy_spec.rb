describe Fastlane do
  describe Fastlane::FastFile do
    describe "create deploy" do
      it "accepts app_identifier" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "deploys", "app.idf@1.0", "new", "--env", "staging"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              app_identifier: 'app.idf',
              env: 'staging')
        end").runner.execute(:test)
      end

      it "accepts build" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "deploys", "1.0+123", "new", "--env", "staging"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              build: '123',
              env: 'staging')
        end").runner.execute(:test)
      end

      it "does not prepend app_identifier if not specified" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "deploys", "1.0", "new", "--env", "staging"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging')
        end").runner.execute(:test)
      end

      it "includes --name if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "deploys", "1.0", "new", "--env", "staging", "--name", "fixture-name"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              name: 'fixture-name')
        end").runner.execute(:test)
      end

      it "includes --url if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "deploys", "1.0", "new", "--env", "staging", "--url", "http://www.sentry.io"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              deploy_url: 'http://www.sentry.io')
        end").runner.execute(:test)
      end

      it "includes --started and --finished if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "deploys", "1.0", "new", "--env", "staging", "--started", 1622630647, "--finished", 1622630700]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              started: 1622630647,
              finished: 1622630700)
        end").runner.execute(:test)
      end

      it "includes --started if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "deploys", "1.0", "new", "--env", "staging", "--started", 1622630647]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              started: 1622630647)
        end").runner.execute(:test)
      end

      it "includes --finished if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "deploys", "1.0", "new", "--env", "staging", "--finished", 1622630700]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              finished: 1622630700)
        end").runner.execute(:test)
      end

      it "includes --time if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["releases", "deploys", "1.0", "new", "--env", "staging", "--time", 180]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              time: 180)
        end").runner.execute(:test)
      end
    end
  end
end
