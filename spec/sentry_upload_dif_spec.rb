describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload-dif" do
      it "fails with API key and auth token" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dsym(
              api_key: 'something123',
              auth_token: 'something123',
              path: '#{dsym_path}'
            )
          end").runner.execute(:test)
        end.to raise_error("Both API key and authentication token found for SentryAction given, please only give one")
      end

      it "fails with invalid dsym path" do
        dsym_path = File.absolute_path './assets/this_does_not_exist.app.dSYM.zip'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
              sentry_upload_dif(
                path: '#{dsym_path}'
              )
          end").runner.execute(:test)
        end.to raise_error("Could not find your symbols file at path '#{dsym_path}'")
      end

      it "includes path if present" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}'
            )
        end").runner.execute(:test)
      end

      it "includes path and paths if both present" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--", dsym_path, dsym_path, dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              paths: ['#{dsym_path}', '#{dsym_path}']
            )
        end").runner.execute(:test)
      end

      it "includes falls back to environment paths if not present" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'
        Fastlane::Actions.lane_context[:DSYM_OUTPUT_PATH] = dsym_path
        Fastlane::Actions.lane_context[:DSYM_PATHS] = [ dsym_path, dsym_path ]

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--", dsym_path, dsym_path, dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif
        end").runner.execute(:test)

        Fastlane::Actions.lane_context[:DSYM_OUTPUT_PATH] = nil
        Fastlane::Actions.lane_context[:DSYM_PATHS] = nil
      end

      it "includes --type for value dsym" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--type", "dsym", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              type: 'dsym'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value elf" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--type", "elf", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              type: 'elf'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value breakpad" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--type", "breakpad", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              type: 'breakpad'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value pdb" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--type", "pdb", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              type: 'pdb'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value pe" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--type", "pe", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              type: 'pe'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value sourcebundle" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--type", "sourcebundle", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              type: 'sourcebundle'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value bcsymbolmap" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--type", "bcsymbolmap", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              type: 'bcsymbolmap'
            )
        end").runner.execute(:test)
      end

      it "fails with unknown --type value" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
              sentry_upload_dif(
                path: '#{dsym_path}',
                type: 'unknown'
              )
          end").runner.execute(:test)
        end.to raise_error("Invalid value 'unknown'")
      end

      it "includes --no-unwind when true" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--no-unwind", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              no_unwind: true
            )
        end").runner.execute(:test)
      end

      it "includes --no-debug when true" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--no-debug", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              no_debug: true
            )
        end").runner.execute(:test)
      end

      it "includes --no-sources when true" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--no-sources", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              no_sources: true
            )
        end").runner.execute(:test)
      end

      it "includes --ids if present" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--ids", "fixture-ids", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              ids: 'fixture-ids'
            )
        end").runner.execute(:test)
      end

      it "includes --require-all when true" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--require-all", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              require_all: true
            )
        end").runner.execute(:test)
      end

      it "includes --symbol-maps if present" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("fixture-symbol-maps").and_return(true)

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--symbol-maps", "fixture-symbol-maps", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              symbol_maps: 'fixture-symbol-maps'
            )
        end").runner.execute(:test)
      end

      it "includes --derived-data when true" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--derived-data", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              derived_data: true
            )
        end").runner.execute(:test)
      end

      it "includes --no-zips when true" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--no-zips", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              no_zips: true
            )
        end").runner.execute(:test)
      end

      it "includes --info-plist if present" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("fixture-info-plist").and_return(true)

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--info-plist", "fixture-info-plist", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              info_plist: 'fixture-info-plist'
            )
        end").runner.execute(:test)
      end

      it "includes --no-reprocessing when true" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--no-reprocessing", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              no_reprocessing: true
            )
        end").runner.execute(:test)
      end

      it "includes --force-foreground when true" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--force-foreground", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              force_foreground: true
            )
        end").runner.execute(:test)
      end

      it "includes --include-sources when true" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--include-sources", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              include_sources: true
            )
        end").runner.execute(:test)
      end

      it "includes --wait when true" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--wait", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              wait: true
            )
        end").runner.execute(:test)
      end

      it "includes --upload-symbol-maps when true" do
        dsym_path = File.absolute_path './assets/SwiftExample.app.dSYM.zip'

        expect(Fastlane::Helper::SentryHelper).to receive(:check_sentry_cli!).and_return(true)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(["sentry-cli", "upload-dif", "--upload-symbol-maps", "--", dsym_path]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dif(
              path: '#{dsym_path}',
              upload_symbol_maps: true
            )
        end").runner.execute(:test)
      end

    end
  end
end
