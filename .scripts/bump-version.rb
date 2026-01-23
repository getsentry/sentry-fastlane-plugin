new_version = ENV.fetch('CRAFT_NEW_VERSION', nil)
old_version = ENV.fetch('CRAFT_OLD_VERSION', nil)

if new_version.nil? || new_version.empty?
  abort "Error: CRAFT_NEW_VERSION environment variable is not set."
end

file_name = "lib/fastlane/plugin/sentry/version.rb"
text = File.read(file_name)

# The whitespaces are important :P
# We try to be safe by matching the old version if provided
if old_version && !old_version.empty?
  pattern = /^    VERSION = "#{Regexp.escape(old_version)}"/
  if text.match?(pattern)
    new_contents = text.gsub(pattern, "    VERSION = \"#{new_version}\"")
  else
    puts "Warning: Previous version #{old_version} not found in #{file_name}. Falling back to general pattern."
    new_contents = text.gsub(/^    VERSION = ".*"/, "    VERSION = \"#{new_version}\"")
  end
else
  new_contents = text.gsub(/^    VERSION = ".*"/, "    VERSION = \"#{new_version}\"")
end

File.write(file_name, new_contents)
