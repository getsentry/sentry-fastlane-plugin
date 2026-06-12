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

  spec.files         = Dir["{bin,lib}/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']

  spec.add_dependency 'os', '~> 1.1', '>= 1.1.4'

  spec.add_development_dependency 'fastlane', '~> 2.10'
  spec.add_development_dependency 'pry', '~> 0.14'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 3.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
