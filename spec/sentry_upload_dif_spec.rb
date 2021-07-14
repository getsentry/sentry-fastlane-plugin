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

      it "includes --no_sources when true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--no_sources"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              no_sources: true
            )
        end").runner.execute(:test)
      end

      it "includes --ids if present" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--ids", "fixture-ids"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              ids: 'fixture-ids'
            )
        end").runner.execute(:test)
      end

      it "includes --require_all when true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--require_all"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              require_all: true
            )
        end").runner.execute(:test)
      end

      it "includes --symbol_maps if present" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--symbol_maps", "fixture-symbol_maps"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              symbol_maps: 'fixture-symbol_maps'
            )
        end").runner.execute(:test)
      end

      it "includes --derived_data when true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--derived_data"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              derived_data: true
            )
        end").runner.execute(:test)
      end

      it "includes --no_zips when true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--no_zips"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              no_zips: true
            )
        end").runner.execute(:test)
      end

      it "includes --info_plist if present" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--info_plist", "fixture-info_plist"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              info_plist: 'fixture-info_plist'
            )
        end").runner.execute(:test)
      end

      it "includes --no_reprocessing when true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--no_reprocessing"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              no_reprocessing: true
            )
        end").runner.execute(:test)
      end

      it "includes --force_foreground when true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--force_foreground"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              force_foreground: true
            )
        end").runner.execute(:test)
      end

      it "includes --include_sources when true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--include_sources"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              include_sources: true
            )
        end").runner.execute(:test)
      end

      it "includes --wait when true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--wait"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              wait: true
            )
        end").runner.execute(:test)
      end

      it "includes --upload_symbol_maps when true" do
        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--paths", "fixture-paths", "--upload_symbol_maps"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              paths: 'fixture-paths',
              upload_symbol_maps: true
            )
        end").runner.execute(:test)
      end

    end
  end
end
