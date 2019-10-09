<p align="center">
    <a href="https://sentry.io" target="_blank" align="center">
        <img src="https://sentry-brand.storage.googleapis.com/sentry-logo-black.png" width="280">
    </a>
<br/>
    <h1>Sentry Fastlane Plugin</h1>
</p>

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-sentry)
[![Build Status](https://img.shields.io/travis/getsentry/fastlane-plugin-sentry/master.svg?style=flat)](https://travis-ci.org/getsentry/fastlane-plugin-sentry)
[![Gem Version](https://badge.fury.io/rb/fastlane-plugin-sentry.svg)](https://badge.fury.io/rb/fastlane-plugin-sentry)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with fastlane-plugin-sentry, add it to your project by running:

```bash
fastlane add_plugin sentry
```

## Sentry Actions

A subset of actions provided by the CLI: https://docs.sentry.io/learn/cli/

#### Authentication & Configuration

`auth_token` is the preferred way to authentication method with Sentry. This can be obtained on https://sentry.io/api/.
`api_key` still works but will eventually become deprecated. This can be obtained through the settings of your project.
Also note that as of version `1.2.0` you no longer have to provide the required parameters, we will try to fallback to your `.sentryclirc` config file if possible.

The following environment variables may be used in place of parameters: `SENTRY_API_KEY`, `SENTRY_AUTH_TOKEN`, `SENTRY_ORG_SLUG`, and `SENTRY_PROJECT_SLUG`.

#### Uploading Symbolication Files

```ruby
sentry_upload_dsym(
  api_key: '...', # Do not use if using auth_token
  auth_token: '...', # Do not use if using api_key
  org_slug: '...',
  project_slug: '...',
  symbol_maps: 'path to bcsymbols folder' # use this if you have a bcsymbols folder
  dsym_path: './App.dSYM.zip',
  info_plist: '...' # optional, sentry-cli tries to find the correct plist by itself
)
```

The `SENTRY_DSYM_PATH` environment variable may be used in place of the `dsym_path` parameter.

#### Creating & Finalizing Releases

```ruby
sentry_create_release(
  api_key: '...',
  auth_token: '...',
  org_slug: '...',
  project_slug: '...',
  version: '...', # release version to create
  app_identifier: '...', # pass in the bundle_identifer of your app
  finalize: true # Whether to finalize the release. If not provided or false, the release can be finalized using the sentry_finalize_release action
)
```

#### Uploading Files & Sourcemaps

Useful for uploading build artifacts and JS sourcemaps for react-native apps built using fastlane.

```ruby
sentry_upload_file(
  api_key: '...',
  auth_token: '...',
  org_slug: '...',
  project_slug: '...',
  version: '...',
  app_identifier: '...', # pass in the bundle_identifer of your app
  dist: '...', # optional distribution of the release usually the buildnumber
  file: 'main.jsbundle' # file to upload
)
```

```ruby
sentry_upload_sourcemap(
  api_key: '...',
  auth_token: '...',
  org_slug: '...',
  project_slug: '...',
  version: '...',
  app_identifier: '...', # pass in the bundle_identifer of your app
  dist: '...', # optional distribution of the release usually the buildnumber
  sourcemap: 'main.jsbundle.map', # sourcemap to upload
  rewrite: true
)
```

#### Associating commits

Useful for telling Sentry which commits are associated with a release.

```ruby
sentry_set_commits(
  version: '...',
  app_identifier: '...', # pass in the bundle_identifer of your app
  auto: false, # enable completely automated commit management
  clear: false, # clear all current commits from the release
  commit: '...', # commit spec, see `sentry-cli releases help set-commits` for more information
)
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

For some more detailed help with plugins problems, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Plugins.md) in the main `fastlane` repo.

## About `fastlane`

`fastlane` automates building, testing, and releasing your app for beta and app store distributions. To learn more about `fastlane`, check out [fastlane.tools](https://fastlane.tools).
