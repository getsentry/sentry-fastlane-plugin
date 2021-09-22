file_name = "lib/fastlane/plugin/sentry/version.rb"

text = File.read(file_name)
# The whitespaces are important :P 
new_contents = text.gsub(/^    VERSION = ".*"/, "    VERSION = \"#{ARGV[1]}\"")
File.open(file_name, "w") {|file| file.puts new_contents }
