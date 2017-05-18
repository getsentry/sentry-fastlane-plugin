describe Fastlane do
  describe Fastlane::FastFile do
    describe "sentry" do
      it "fails with invalid file path" do
        file_path = File.absolute_path './assets/this_does_not_exist.js'
        expect do
          Fastlane::FastFile.new.parse("lane :test do
            sentry_upload_file(
              org_slug: 'some_org',
              api_key: 'something123',
              project_slug: 'some_project',
              file: '#{file_path}')
          end").runner.execute(:test)
        end.to raise_error("Could not find file at path '#{file_path}'")
      end
    end
  end
end
