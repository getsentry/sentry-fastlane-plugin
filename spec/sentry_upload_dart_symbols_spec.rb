describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload dart symbols" do
      it "fails with non-existent symbol map path" do
        symbol_map_path = File.absolute_path './assets/this.does.not.exist.json'
        debug_file_paths = [File.absolute_path('./assets/AndroidManifest.xml')]

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dart_symbols(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              symbol_map_path: '#{symbol_map_path}',
              debug_file_paths: #{debug_file_paths})
          end").runner.execute(:test)
        end.to raise_error("Symbol map file not found at path '#{symbol_map_path}'")
      end

      it "fails with non-existent debug file path" do
        symbol_map_path = File.absolute_path './assets/AndroidManifest.xml'
        debug_file_path = File.absolute_path './assets/this.does.not.exist.so'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dart_symbols(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              symbol_map_path: '#{symbol_map_path}',
              debug_file_paths: ['#{debug_file_path}'])
          end").runner.execute(:test)
        end.to raise_error("Debug file does not exist at path: #{debug_file_path}")
      end

      it "fails with empty debug_file_paths array" do
        symbol_map_path = File.absolute_path './assets/AndroidManifest.xml'

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dart_symbols(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              symbol_map_path: '#{symbol_map_path}',
              debug_file_paths: [])
          end").runner.execute(:test)
        end.to raise_error("debug_file_paths cannot be empty")
      end

      it "calls dart-symbol-map upload with single debug file" do
        symbol_map_path = File.absolute_path './assets/AndroidManifest.xml'
        debug_file_path = File.absolute_path './assets/AndroidManifest.xml'

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)

        # Mock fetch_debug_id to return a debug ID
        allow(Fastlane::Actions::SentryUploadDartSymbolsAction).to receive(:fetch_debug_id).and_return('test-debug-id-123')

        # Mock prepend_debug_id_marker to avoid file modification
        allow(Fastlane::Actions::SentryUploadDartSymbolsAction).to receive(:prepend_debug_id_marker).and_return(nil)

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli)
          .with(anything, ["dart-symbol-map", "upload", "--org", "some_org", "--project", "some_project", symbol_map_path, debug_file_path])
          .and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dart_symbols(
            org_slug: 'some_org',
            auth_token: 'something123',
            project_slug: 'some_project',
            symbol_map_path: '#{symbol_map_path}',
            debug_file_paths: ['#{debug_file_path}'])
        end").runner.execute(:test)
      end

      it "calls dart-symbol-map upload multiple times for multiple debug files" do
        symbol_map_path = File.absolute_path './assets/AndroidManifest.xml'
        debug_file_path_1 = File.absolute_path './assets/AndroidManifest.xml'
        debug_file_path_2 = File.absolute_path './assets/AndroidExample.mapping.txt'

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)

        # Mock fetch_debug_id to return different debug IDs
        allow(Fastlane::Actions::SentryUploadDartSymbolsAction).to receive(:fetch_debug_id)
          .and_return('test-debug-id-1', 'test-debug-id-2')

        # Mock prepend_debug_id_marker to avoid file modification
        allow(Fastlane::Actions::SentryUploadDartSymbolsAction).to receive(:prepend_debug_id_marker).and_return(nil)

        # Expect two separate upload calls
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli)
          .with(anything, ["dart-symbol-map", "upload", "--org", "some_org", "--project", "some_project", symbol_map_path, debug_file_path_1])
          .and_return(true)

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli)
          .with(anything, ["dart-symbol-map", "upload", "--org", "some_org", "--project", "some_project", symbol_map_path, debug_file_path_2])
          .and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dart_symbols(
            org_slug: 'some_org',
            auth_token: 'something123',
            project_slug: 'some_project',
            symbol_map_path: '#{symbol_map_path}',
            debug_file_paths: ['#{debug_file_path_1}', '#{debug_file_path_2}'])
        end").runner.execute(:test)
      end

      it "includes --wait flag when specified" do
        symbol_map_path = File.absolute_path './assets/AndroidManifest.xml'
        debug_file_path = File.absolute_path './assets/AndroidManifest.xml'

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)

        # Mock fetch_debug_id and prepend_debug_id_marker
        allow(Fastlane::Actions::SentryUploadDartSymbolsAction).to receive(:fetch_debug_id).and_return('test-debug-id-123')
        allow(Fastlane::Actions::SentryUploadDartSymbolsAction).to receive(:prepend_debug_id_marker).and_return(nil)

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli)
          .with(anything, ["dart-symbol-map", "upload", "--org", "some_org", "--project", "some_project", "--wait", symbol_map_path, debug_file_path])
          .and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dart_symbols(
            org_slug: 'some_org',
            auth_token: 'something123',
            project_slug: 'some_project',
            symbol_map_path: '#{symbol_map_path}',
            debug_file_paths: ['#{debug_file_path}'],
            wait: true)
        end").runner.execute(:test)
      end

      it "continues on partial failures and reports summary" do
        symbol_map_path = File.absolute_path './assets/AndroidManifest.xml'
        debug_file_path_1 = File.absolute_path './assets/AndroidManifest.xml'
        debug_file_path_2 = File.absolute_path './assets/AndroidExample.mapping.txt'

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)

        # Mock fetch_debug_id and prepend_debug_id_marker
        allow(Fastlane::Actions::SentryUploadDartSymbolsAction).to receive(:fetch_debug_id).and_return('test-debug-id')
        allow(Fastlane::Actions::SentryUploadDartSymbolsAction).to receive(:prepend_debug_id_marker).and_return(nil)

        # First call succeeds, second fails
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli)
          .with(anything, ["dart-symbol-map", "upload", "--org", "some_org", "--project", "some_project", symbol_map_path, debug_file_path_1])
          .and_return(true)

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli)
          .with(anything, ["dart-symbol-map", "upload", "--org", "some_org", "--project", "some_project", symbol_map_path, debug_file_path_2])
          .and_raise(StandardError.new("Upload failed"))

        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_dart_symbols(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              symbol_map_path: '#{symbol_map_path}',
              debug_file_paths: ['#{debug_file_path_1}', '#{debug_file_path_2}'])
          end").runner.execute(:test)
        end.to raise_error(/Failed to upload 1 out of 2/)
      end

      it "proceeds without marker modification when debug ID cannot be fetched" do
        symbol_map_path = File.absolute_path './assets/AndroidManifest.xml'
        debug_file_path = File.absolute_path './assets/AndroidManifest.xml'

        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)

        # Mock fetch_debug_id to return nil
        allow(Fastlane::Actions::SentryUploadDartSymbolsAction).to receive(:fetch_debug_id).and_return(nil)

        # prepend_debug_id_marker should not be called
        expect(Fastlane::Actions::SentryUploadDartSymbolsAction).not_to receive(:prepend_debug_id_marker)

        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli)
          .with(anything, ["dart-symbol-map", "upload", "--org", "some_org", "--project", "some_project", symbol_map_path, debug_file_path])
          .and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
          sentry_upload_dart_symbols(
            org_slug: 'some_org',
            auth_token: 'something123',
            project_slug: 'some_project',
            symbol_map_path: '#{symbol_map_path}',
            debug_file_paths: ['#{debug_file_path}'])
        end").runner.execute(:test)
      end
    end
  end
end
