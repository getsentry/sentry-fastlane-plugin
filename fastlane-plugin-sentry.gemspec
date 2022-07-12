lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/sentry/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.6.0'
  spec.name          = 'fastlane-plugin-sentry'
  spec.version       = Fastlane::Sentry::VERSION
  spec.author        = %q{Sentry}
  spec.email         = %q{hello@sentry.io}

  spec.summary       = %q{Upload symbols to Sentry}
  spec.homepage      = "https://github.com/getsentry/sentry-fastlane-plugin"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE bin/sentry-cli)
  spec.executables << 'sentry_cli_path'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'fastlane', '>= 2.10.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
