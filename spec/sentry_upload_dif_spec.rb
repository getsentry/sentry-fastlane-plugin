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

      it "includes --types for value dsym" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--types", "dsym"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              types: 'dsym'
            )
        end").runner.execute(:test)
      end

      it "includes --types for value elf" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--types", "elf"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              types: 'elf'
            )
        end").runner.execute(:test)
      end

      it "includes --types for value breakpad" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--types", "breakpad"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              types: 'breakpad'
            )
        end").runner.execute(:test)
      end

      it "includes --types for value pdb" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--types", "pdb"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              types: 'pdb'
            )
        end").runner.execute(:test)
      end

      it "includes --types for value pe" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--types", "pe"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              types: 'pe'
            )
        end").runner.execute(:test)
      end

      it "includes --types for value sourcebundle" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--types", "sourcebundle"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              types: 'sourcebundle'
            )
        end").runner.execute(:test)
      end

      it "includes --types for value bcsymbolmap" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--types", "bcsymbolmap"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              types: 'bcsymbolmap'
            )
        end").runner.execute(:test)
      end

      it "fails with unknown --types value" do
        dsym_path_1 = File.absolute_path './assets/this_does_not_exist.app.dSYM.zip'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
              sentry_upload_dif(
                paths: 'fixture-paths',
                types: 'unknown'
              )
          end").runner.execute(:test)
        end.to raise_error("Invalid value 'unknown'")
      end

      it "includes --no_unwind when true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--no_unwind"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              no_unwind: true
            )
        end").runner.execute(:test)
      end

      it "includes --no_debug when true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--no_debug"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              no_debug: true
            )
        end").runner.execute(:test)
      end

    end
  end
end
