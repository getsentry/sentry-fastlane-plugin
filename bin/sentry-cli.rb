#!/usr/bin/env ruby

# Wrap executable to call sentry-cli binary
bin_dir = File.expand_path(File.dirname(__FILE__))
executable_path = File.join(bin_dir, 'sentry-cli')

# Pass along all parameters
executable_call = "#{executable_path}"
ARGV.each do|a|
  executable_call += " #{a}"
end

# Execute
puts `#{executable_call}`
