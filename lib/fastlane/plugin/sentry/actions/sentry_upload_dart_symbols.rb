module Fastlane
  module Actions
    class SentryUploadDartSymbolsAction < Action
      def self.run(params)
        require 'shellwords'
        require 'json'

        Helper::SentryConfig.parse_api_params(params)

        symbol_map_path = params[:symbol_map_path]
        debug_file_paths = params[:debug_file_paths]

        # Validate symbol map file exists
        UI.user_error!("Symbol map file does not exist at path: #{symbol_map_path}") unless File.exist?(symbol_map_path)

        # Validate all debug files exist
        debug_file_paths.each do |debug_file|
          UI.user_error!("Debug file does not exist at path: #{debug_file}") unless File.exist?(debug_file)
        end

        # Track upload statistics
        attempted = 0
        succeeded = 0
        failed = 0

        begin
          debug_file_paths.each do |debug_file_path|
            attempted += 1

            # Fetch debug ID for the debug file
            debug_id = fetch_debug_id(params, debug_file_path)

            if debug_id && !debug_id.empty?
              # Prepend debug ID marker to the symbol map
              prepend_debug_id_marker(symbol_map_path, debug_id)
            else
              UI.important("Could not resolve debug id for \"#{debug_file_path}\". Proceeding without map modification.")
            end

            UI.message("Uploading Dart symbol map '#{symbol_map_path}' paired with '#{debug_file_path}'")

            # Build the upload command
            command = [
              "dart-symbol-map",
              "upload"
            ]

            # Add org and project
            command.push('--org').push(params[:org_slug]) unless params[:org_slug].nil?
            command.push('--project').push(params[:project_slug]) unless params[:project_slug].nil?

            # Add the symbol map and debug file paths
            command.push(symbol_map_path)
            command.push(debug_file_path)

            # Execute the upload command
            begin
              Helper::SentryHelper.call_sentry_cli(params, command)
              succeeded += 1
            rescue StandardError => e
              UI.error("Failed to upload Dart symbol map for #{debug_file_path}: #{e.message}")
              failed += 1
            end
          end
        ensure
          UI.message("Dart symbol map upload summary: attempted=#{attempted}, succeeded=#{succeeded}, failed=#{failed}")
        end

        if failed > 0
          UI.user_error!("Failed to upload #{failed} out of #{attempted} Dart symbol map(s)")
        else
          UI.success("Successfully uploaded Dart symbol map(s)")
        end
      end

      # Fetch debug ID for a debug file using sentry-cli debug-files check --json
      def self.fetch_debug_id(params, debug_file_path)
        begin
          sentry_path = Helper::SentryHelper.find_and_check_sentry_cli_path!(params)
          command = [
            sentry_path,
            "debug-files",
            "check",
            "--json",
            debug_file_path
          ].map { |arg| Shellwords.escape(arg) }.join(" ")

          require 'open3'
          stdout_str, stderr_str, status = Open3.capture3(command)

          unless status.success?
            UI.important("Failed to fetch debug id for \"#{debug_file_path}\" (exit=#{status.exitstatus}): #{stderr_str.strip}")
            return nil
          end

          return nil if stdout_str.strip.empty?

          # Parse JSON output
          parsed = JSON.parse(stdout_str)
          unless parsed.is_a?(Hash)
            UI.important("Unexpected JSON when fetching debug id for \"#{debug_file_path}\"")
            return nil
          end

          variants = parsed['variants']
          if variants.is_a?(Array) && !variants.empty?
            first = variants.first
            if first.is_a?(Hash) && first['debug_id'].is_a?(String)
              return first['debug_id']
            end
          end

          UI.important("No debug id found in variants for \"#{debug_file_path}\"")
          nil
        rescue StandardError => e
          UI.important("Exception while fetching debug id for \"#{debug_file_path}\": #{e.message}")
          nil
        end
      end

      # Prepend debug ID marker to the symbol map file
      def self.prepend_debug_id_marker(map_path, debug_id)
        debug_id_marker = 'SENTRY_DEBUG_ID_MARKER'

        begin
          unless File.exist?(map_path)
            UI.important("Cannot modify Dart symbol map: file does not exist at '#{map_path}'.")
            return
          end

          # Read and parse the symbol map
          raw = File.read(map_path)
          decoded = JSON.parse(raw)

          unless decoded.is_a?(Array)
            UI.important('Cannot modify Dart symbol map: top-level JSON is not an array.')
            return
          end

          original = decoded.dup

          # If the file already has the same marker with the same debug ID, do nothing
          if original.length >= 2 && original[0] == debug_id_marker && original[1] == debug_id
            return
          end

          # Determine the tail (everything after the marker, if present)
          tail = if !original.empty? && original.first == debug_id_marker
                   original.length > 2 ? original[2..-1] : []
                 else
                   original
                 end

          # Build the updated array with the marker prepended
          updated = [debug_id_marker, debug_id] + tail

          # Write back to the file
          File.write(map_path, JSON.generate(updated))
        rescue StandardError => e
          UI.important("Failed to modify Dart symbol map before upload: #{e.message}")
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload Dart symbol maps paired with native debug files"
      end

      def self.details
        [
          "This action uploads a Dart obfuscation map paired with each provided native debug file.",
          "For each debug file, the action fetches its debug ID and prepends it to the symbol map",
          "to ensure proper pairing in Sentry. This is essential for symbolication of Dart/Flutter",
          "crash reports in obfuscated builds.",
          "See https://docs.sentry.io/platforms/flutter/upload-debug/ for more information."
        ].join(" ")
      end

      def self.available_options
        Helper::SentryConfig.common_api_config_items + [
          FastlaneCore::ConfigItem.new(key: :symbol_map_path,
                                       description: "Path to the Dart symbol map file (typically symbols.json from Flutter build)",
                                       optional: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("Symbol map file not found at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :debug_file_paths,
                                       description: "Array of paths to native debug files (dSYMs, .so files, etc.) to pair with the symbol map",
                                       type: Array,
                                       optional: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("debug_file_paths must be an array") unless value.is_a?(Array)
                                         UI.user_error!("debug_file_paths cannot be empty") if value.empty?
                                       end)
        ]
      end

      def self.return_value
        nil
      end

      def self.authors
        ["getsentry"]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
