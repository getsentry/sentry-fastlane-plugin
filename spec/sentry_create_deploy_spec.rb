describe Fastlane do
  describe Fastlane::FastFile do
    describe "create deploy" do
      it "accepts app_identifier" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "releases", "deploys", "app.idf@1.0", "new", "--env", "staging"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              app_identifier: 'app.idf',
              env: 'staging')
        end").runner.execute(:test)
      end

      it "does not prepend app_identifier if not specified" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "releases", "deploys", "1.0", "new", "--env", "staging"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging')
        end").runner.execute(:test)
      end

      it "includes --name if present" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "releases", "deploys", "1.0", "new", "--env", "staging", "--name", "fixture-name"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              name: 'fixture-name')
        end").runner.execute(:test)
      end

      it "includes --url if present" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "releases", "deploys", "1.0", "new", "--env", "staging", "--url", "www.sentry.io"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              deploy_url: 'www.sentry.io')
        end").runner.execute(:test)
      end

      it "includes --started and --finished if present" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "releases", "deploys", "1.0", "new", "--env", "staging", "--started", 1622630647, "--finished", 1622630700]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              started: 1622630647,
              finished: 1622630700)
        end").runner.execute(:test)
      end

      it "fails if started present without finished" do
        expect do
          Fastlane::FastFile.new.parse("lane :test do
              sentry_create_deploy(
                version: '1.0',
                env: 'staging',
                started: 1622630647)
          end").runner.execute(:test)
        end.to raise_error("Only one parmeter of 'started' and 'finished' found, please provide both.")
      end

      it "fails if finished present without started" do
        expect do
          Fastlane::FastFile.new.parse("lane :test do
              sentry_create_deploy(
                version: '1.0',
                env: 'staging',
                finished: 1622630700)
          end").runner.execute(:test)
        end.to raise_error("Only one parmeter of 'started' and 'finished' found, please provide both.")
      end

      it "omit --started and --finished if time if present" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "releases", "deploys", "1.0", "new", "--env", "staging", "--time", 180]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              time: 180,
              started: 1622630647,
              finished: 1622630700)
        end").runner.execute(:test)
      end

      it "omit --started if time if present" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "releases", "deploys", "1.0", "new", "--env", "staging", "--time", 180]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              time: 180,
              started: 1622630647)
        end").runner.execute(:test)
      end

      it "omit --finished if time if present" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "releases", "deploys", "1.0", "new", "--env", "staging", "--time", 180]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_create_deploy(
              version: '1.0',
              env: 'staging',
              time: 180,
              finished: 1622630700)
        end").runner.execute(:test)
      end
    end
  end
end
