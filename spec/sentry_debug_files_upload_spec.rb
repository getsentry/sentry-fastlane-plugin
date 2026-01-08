describe Fastlane do
  describe Fastlane::FastFile do
    describe "debug-files upload" do
      it "includes --path if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path'
            )
        end").runner.execute(:test)
      end

      it "supports mupltiple paths as array" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "fixture-path-2"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: ['fixture-path', 'fixture-path-2']
            )
        end").runner.execute(:test)
      end

      it "supports mupltiple paths as comma seperated values" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "fixture-path-2"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path,fixture-path-2'
            )
        end").runner.execute(:test)
      end

      it "includes --path fallback if not present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "."]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload()
        end").runner.execute(:test)
      end

      it "includes --type for value dsym" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--type", "dsym"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              type: 'dsym'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value elf" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--type", "elf"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              type: 'elf'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value breakpad" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--type", "breakpad"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              type: 'breakpad'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value pdb" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--type", "pdb"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              type: 'pdb'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value pe" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--type", "pe"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              type: 'pe'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value sourcebundle" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--type", "sourcebundle"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              type: 'sourcebundle'
            )
        end").runner.execute(:test)
      end

      it "includes --type for value bcsymbolmap" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--type", "bcsymbolmap"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              type: 'bcsymbolmap'
            )
        end").runner.execute(:test)
      end

      it "fails with unknown --type value" do
        dsym_path_1 = File.absolute_path './assets/this_does_not_exist.app.dSYM.zip'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
              sentry_debug_files_upload(
                path: 'fixture-path',
                type: 'unknown'
              )
          end").runner.execute(:test)
        end.to raise_error("Invalid value 'unknown'")
      end

      it "includes --no_unwind when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--no-unwind"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              no_unwind: true
            )
        end").runner.execute(:test)
      end

      it "includes --no_debug when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--no-debug"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              no_debug: true
            )
        end").runner.execute(:test)
      end

      it "includes --no_sources when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--no-sources"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              no_sources: true
            )
        end").runner.execute(:test)
      end

      it "includes --ids if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--ids", "fixture-ids"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              ids: 'fixture-ids'
            )
        end").runner.execute(:test)
      end

      it "includes --require_all when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--require-all"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              require_all: true
            )
        end").runner.execute(:test)
      end

      it "includes --symbol_maps if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--symbol-maps", "fixture-symbol_maps"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              symbol_maps: 'fixture-symbol_maps'
            )
        end").runner.execute(:test)
      end

      it "includes --derived_data when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--derived-data"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              derived_data: true
            )
        end").runner.execute(:test)
      end

      it "includes --no_zips when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--no-zips"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              no_zips: true
            )
        end").runner.execute(:test)
      end

      it "includes --info_plist if present" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--info-plist", "fixture-info_plist"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              info_plist: 'fixture-info_plist'
            )
        end").runner.execute(:test)
      end

      it "includes --no_reprocessing when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--no-reprocessing"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              no_reprocessing: true
            )
        end").runner.execute(:test)
      end


      it "includes --include_sources when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--include-sources"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              include_sources: true
            )
        end").runner.execute(:test)
      end

      it "dont include --include_sources when false" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              include_sources: false
            )
        end").runner.execute(:test)
      end

      it "includes --wait when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--wait"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              wait: true
            )
        end").runner.execute(:test)
      end

      it "includes --upload_symbol_maps when true" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["debug-files", "upload", "fixture-path", "--upload-symbol-maps"]).and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_debug_files_upload(
              path: 'fixture-path',
              upload_symbol_maps: true
            )
        end").runner.execute(:test)
      end
    end
  end
end
