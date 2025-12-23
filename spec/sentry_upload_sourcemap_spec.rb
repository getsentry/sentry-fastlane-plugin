describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload_sourcemap" do
      it "fails with invalid sourcemap path" do
        sourcemap_path = File.absolute_path './assets/this_does_not_exist.js.map'
        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              sourcemap: '#{sourcemap_path}')
          end").runner.execute(:test)
        end.to raise_error("Could not find sourcemap at path '#{sourcemap_path}'")
      end

      it "does not require dist to be specified" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemaps", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.map").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              sourcemap: '1.map',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "accepts app_identifier" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemaps", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.map").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "accepts build" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemaps", "upload", "--release", "1.0+123", "1.map", "--no-rewrite", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.map").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map',
              build: '123')
        end").runner.execute(:test)
      end

      it "uses input value for strip_prefix" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemaps", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite", "--strip-prefix", "/Users/get-sentry/semtry-fastlane-plugin", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.map").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map',
              app_identifier: 'app.idf',
              strip_prefix: '/Users/get-sentry/semtry-fastlane-plugin',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "accepts strip_common_prefix" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemaps", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite", "--strip-common-prefix", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.map").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map',
              strip_common_prefix: true,
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "does not prepend strip_common_prefix if not specified" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemaps", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.map").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "does not prepend app_identifier if not specified" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemaps", "upload", "--release", "1.0", "1.map", "--no-rewrite", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.map").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map')
        end").runner.execute(:test)
      end

      it "default --no-rewrite is omitted when 'rewrite' is specified" do
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemaps", "upload", "--release", "1.0", "1.map", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.map").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map',
              rewrite: true)
        end").runner.execute(:test)
      end

      it "accepts multiple source maps as an array" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemaps", "upload", "--release", "app.idf@1.0", "1.bundle", "1.map", "--no-rewrite", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.bundle").and_return(true)
        expect(File).to receive(:exist?).with("1.map").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: ['1.bundle', '1.map'],
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "accepts multiple source maps as a comma-separated string" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        expect(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemaps", "upload", "--release", "app.idf@1.0", "1.bundle", "1.map", "--no-rewrite", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        expect(File).to receive(:exist?).with("1.bundle").and_return(true)
        expect(File).to receive(:exist?).with("1.map").and_return(true)

        Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.bundle,1.map',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end
    end
  end
end
