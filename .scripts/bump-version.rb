ref_name = `git branch --show-current`
sdk_name_capture_regex = /release-(sentry-\w+)\/.*/

file_name "lib/fastlane/plugin/sentry/version.rb"

text = File.read(file_name)
new_contents = text.gsub(/VERSION = ".*"/, "VERSION = \"#{ARGV[1]}\"")
File.open(file_name, "w") {|file| file.puts new_contents }
