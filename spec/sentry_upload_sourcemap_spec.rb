describe Fastlane do
  describe Fastlane::FastFile do
    describe "sentry" do
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
    end
  end
end
