module Fastlane
  module Actions
    class SentryUploadDsymAction < Action
      def self.run(params)

        require 'rest-client'

        # Params - API
        host = params[:api_host]
        api_key = params[:api_key]
        auth_token = params[:auth_token]
        org = params[:org_slug]
        project = params[:project_slug]
        timeout = params[:timeout]
        use_curl = params[:use_curl]

        # Params - dSYM
        dsym_path = params[:dsym_path]
        dsym_paths = params[:dsym_paths] || []

        has_api_key = !api_key.to_s.empty?
        has_auth_token = !auth_token.to_s.empty?

        # Will fail if none or both authentication methods are provided
        if !has_api_key && !has_auth_token
          UI.user_error!("No API key or authentication token found for SentryAction given, pass using `api_key: 'key'` or `auth_token: 'token'`")
        elsif has_api_key && has_auth_token
          UI.user_error!("Both API key and authentication token found for SentryAction given, please only give one")
        end

        # Url to post dSYMs to
        url = "#{host}/projects/#{org}/#{project}/files/dsyms/"

        UI.message "Will upload dSYM(s) to #{url}"

        # Verify dsym(s)
        dsym_paths += [dsym_path]
        dsym_paths = dsym_paths.map { |path| File.absolute_path(path) }
        dsym_paths.each do |path|
          UI.user_error!("dSYM does not exist at path: #{path}") unless File.exists? path
        end

        # Upload dsym(s)
        uploaded_paths = dsym_paths.compact.map do |dsym|
          upload_dsym(use_curl, dsym, url, timeout, api_key, auth_token)
        end

        # Return uplaoded dSYM paths
        uploaded_paths
      end

      def self.upload_dsym(use_curl, dsym, url, timeout, api_key, auth_token)
        UI.message "Uploading... #{dsym}"
        if use_curl
          self.upload_dsym_curl(dsym, url, timeout, api_key, auth_token)
        else
          self.upload_dsym_restclient(dsym, url, timeout, api_key, auth_token)
        end
      end
      
      def self.upload_dsym_curl(dsym, url, timeout, api_key, auth_token)
        has_api_key = !api_key.to_s.empty?
        
        status = 0
        if has_api_key
          status = sh "curl -s -o /dev/null -w '%{response_code}' --max-time #{timeout} --user #{api_key}: -F file=@#{dsym} #{url} | grep -o  '[1-4][0-9][0-9]' "
        else
          status = sh "curl -s -o /dev/null -w '%{response_code}' --max-time #{timeout} -H 'Authorization: Bearer #{auth_token}'  -F file=@#{dsym} #{url} | grep -o  '[1-4][0-9][0-9]' "
        end
        
        status = status.to_i
        if (200..299).member?(status)
          return dsym
        else
          self.handle_error(nil, status)
        end
      end
      
      def self.upload_dsym_restclient(dsym, url, timeout, api_key, auth_token)
        has_api_key = !api_key.to_s.empty?
        
        if has_api_key
          resource = RestClient::Resource.new( url, user: api_key, password: '', timeout: timeout, open_timeout: timeout )
        else
          resource = RestClient::Resource.new( url, headers: {Authorization: "Bearer #{auth_token}"}, timeout: timeout, open_timeout: timeout )
        end
        
        begin
          resource.post(file: File.new(dsym, 'rb')) unless Helper.test?
          UI.success 'dSYM successfully uploaded to Sentry!'
          dsym
        rescue RestClient::Exception => error
          handle_error(error, error.http_code)
        rescue => error
          handle_error(error)
        end
      end

      def self.handle_error(error, status = 0)
        UI.error "Error: #{error}" if error
        UI.important "Make sure your api_key or auth_token is configured correctly" if status == 401
        UI.important "Make sure the org_slug and project_slug matches exactly what is displayed your admin panel's URL" if status == 404
        UI.important "Your upload may have timed out for an unknown reason" if status == 100
        UI.user_error! 'Error while trying to upload dSYM to Sentry'
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload dSYM symbolication files to Sentry"
      end

      def self.details
        [
          "This action allows you to upload symbolication files to Sentry.",
          "It's extra useful if you use it to download the latest dSYM files from Apple when you",
          "use Bitcode"
        ].join(" ")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_host,
                                       env_name: "SENTRY_HOST",
                                       description: "API host url for Sentry",
                                       is_string: true,
                                       default_value: "https://app.getsentry.com/api/0",
                                       optional: true
                                      ),
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       env_name: "SENTRY_API_KEY",
                                       description: "API key for Sentry",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :auth_token,
                                       env_name: "SENTRY_AUTH_TOKEN",
                                       description: "Authentication token for Sentry",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :org_slug,
                                       env_name: "SENTRY_ORG_SLUG",
                                       description: "Organization slug for Sentry project",
                                       verify_block: proc do |value|
                                         UI.user_error!("No organization slug for SentryAction given, pass using `org_slug: 'org'`") unless value and !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :project_slug,
                                       env_name: "SENTRY_PROJECT_SLUG",
                                       description: "Prgoject slug for Sentry",
                                       verify_block: proc do |value|
                                         UI.user_error!("No project slug for SentryAction given, pass using `project_slug: 'project'`") unless value and !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :dsym_path,
                                       env_name: "SENTRY_DSYM_PATH",
                                       description: "Path to your symbols file. For iOS and Mac provide path to app.dSYM.zip",
                                       default_value: Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH],
                                       optional: true,
                                       verify_block: proc do |value|
                                         # validation is done in the action
                                       end),
          FastlaneCore::ConfigItem.new(key: :dsym_paths,
                                       env_name: "SENTRY_DSYM_PATHS",
                                       description: "Path to an array of your symbols file. For iOS and Mac provide path to app.dSYM.zip",
                                       default_value: Actions.lane_context[SharedValues::DSYM_PATHS],
                                       is_string: false,
                                       optional: true,
                                       verify_block: proc do |value|
                                         # validation is done in the action
                                       end),
          FastlaneCore::ConfigItem.new(key: :timeout,
                                       env_name: "SENTRY_TIMEOUT",
                                       description: "Sentry upload API request timeout (in seconds)",
                                       default_value: 120,
                                       is_string: false,
                                       optional: true,
                                       verify_block: proc do |value|
                                         # validation is done in the action
                                       end),
           FastlaneCore::ConfigItem.new(key: :use_curl,
                                       env_name: "SENTRY_USE_CURL",
                                       description: "Shells out the upload to `curl` instead of using `rest-client`. This MAY be needed for really large dSYM file sizes. Use this if you are receving timeouts",
                                       default_value: false,
                                       is_string: false,
                                       optional: true,
                                       verify_block: proc do |value|
                                         # validation is done in the action
                                       end)
                                       
        ]
      end

      def self.return_value
        "The uploaded dSYM path(s)"
      end

      def self.authors
        ["joshdholtz"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
