describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload_sourcemap" do
      it "fails with invalid sourcemap path" do
        sourcemap_path = File.absolute_path './assets/this_does_not_exist.js.map'
        expect do
          described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              sourcemap: '#{sourcemap_path}')
          end").runner.execute(:test)
        end.to raise_error("Could not find sourcemap at path '#{sourcemap_path}'")
      end

      it "does not require dist to be specified" do
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        allow(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("1.map").and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              sourcemap: '1.map',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "accepts app_identifier" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        allow(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("1.map").and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "accepts build" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        allow(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "1.0+123", "1.map", "--no-rewrite", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("1.map").and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map',
              build: '123')
        end").runner.execute(:test)
      end

      it "uses input value for strip_prefix" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        allow(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite", "--strip-prefix", "/Users/get-sentry/semtry-fastlane-plugin", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("1.map").and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
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
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        allow(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite", "--strip-common-prefix", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("1.map").and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
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
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        allow(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("1.map").and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "does not prepend app_identifier if not specified" do
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        allow(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "1.0", "1.map", "--no-rewrite", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("1.map").and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map')
        end").runner.execute(:test)
      end

      it "default --no-rewrite is omitted when 'rewrite' is specified" do
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        allow(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "1.0", "1.map", "--dist", "dem"]).and_return(true)

        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("1.map").and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.map',
              rewrite: true)
        end").runner.execute(:test)
      end

      it "uploads every directory of an array separately" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "app.idf@1.0", "1.bundle", "--no-rewrite", "--dist", "dem"]).ordered.and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite", "--dist", "dem"]).ordered.and_return(true)

        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("1.bundle").and_return(true)
        allow(File).to receive(:exist?).with("1.map").and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: ['1.bundle', '1.map'],
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "uploads every directory of a comma-separated string separately" do
        allow(CredentialsManager::AppfileConfig).to receive(:try_fetch_value).with(:app_identifier).and_return(false)
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "app.idf@1.0", "1.bundle", "--no-rewrite", "--dist", "dem"]).ordered.and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "app.idf@1.0", "1.map", "--no-rewrite", "--dist", "dem"]).ordered.and_return(true)

        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("1.bundle").and_return(true)
        allow(File).to receive(:exist?).with("1.map").and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              dist: 'dem',
              sourcemap: '1.bundle,1.map',
              app_identifier: 'app.idf')
        end").runner.execute(:test)
      end

      it "joins ext values with commas" do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("dist").and_return(true)
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "1.0", "dist", "--no-rewrite", "--ext", "js,jsbundle"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              sourcemap: 'dist',
              ext: ['js', 'jsbundle'])
        end").runner.execute(:test)
      end

      it "joins ignore globs with commas and includes --ignore-file" do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("dist").and_return(true)
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "1.0", "dist", "--no-rewrite", "--ignore", "node_modules/**,*.test.js", "--ignore-file", ".sentryignore"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              sourcemap: 'dist',
              ignore: ['node_modules/**', '', '*.test.js'],
              ignore_file: '.sentryignore')
        end").runner.execute(:test)
      end

      it "includes --url-prefix if present" do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("dist").and_return(true)
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "1.0", "dist", "--no-rewrite", "--url-prefix", "~/static/js"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              sourcemap: 'dist',
              url_prefix: '~/static/js')
        end").runner.execute(:test)
      end

      it "ignores options the Sentry CLI no longer supports" do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("dist").and_return(true)
        allow(Fastlane::Helper::SentryConfig).to receive(:parse_api_params).and_return(true)
        deprecated_options = %w[url_suffix note validate decompress wait wait_for no_sourcemap_reference debug_id_reference bundle bundle_sourcemap strict]
        deprecated_options.each do |option|
          expect(FastlaneCore::UI).to receive(:deprecated).with(a_string_including(option))
        end
        expect(Fastlane::Helper::SentryHelper).to receive(:call_sentry_cli).with(anything, ["sourcemap", "upload", "--release", "1.0", "dist", "--no-rewrite"]).and_return(true)

        described_class.new.parse("lane :test do
            sentry_upload_sourcemap(
              org_slug: 'some_org',
              auth_token: 'something123',
              project_slug: 'some_project',
              version: '1.0',
              sourcemap: 'dist',
              url_suffix: '.map',
              note: 'Build from CI',
              validate: true,
              decompress: true,
              wait: true,
              wait_for: 60,
              no_sourcemap_reference: true,
              debug_id_reference: true,
              bundle: 'main.jsbundle',
              bundle_sourcemap: 'main.jsbundle.map',
              strict: true)
        end").runner.execute(:test)
      end
    end
  end
end
