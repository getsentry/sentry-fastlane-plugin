# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/sentry/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-sentry'
  spec.version       = Fastlane::Sentry::VERSION
  spec.author        = %q{Josh Holtz}
  spec.email         = %q{josh@rokkincat.com}

  spec.summary       = %q{Upload symbols to Sentry}
  spec.homepage      = "https://github.com/getsentry/sentry-fastlane"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'fastlane', '>= 1.93.0'
end
