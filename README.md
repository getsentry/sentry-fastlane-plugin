# fastlane-plugin-sentry `fastlane` Plugin

[![fastlane Plugin Badge](https://raw.githubusercontent.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-sentry)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with fastlane-plugin-sentry, add it to your project by running:

```bash
fastlane add_plugin sentry
```

## About sentry

This action allows you to upload symbolication files to Sentry.

```ruby
sentry_upload_dsym(
  api_key: '...', # Do not use if using auth_token
  auth_token: '...', # Do not use if using api_key
  org_slug: '...',
  project_slug: '...',
  dsym_path: './App.dSYM.zip'
)
```

`auth_token` is the preferred way to authentication method with Sentry. `api_key` will eventually become deprecated.

The following environment variables may be used in place of parameters: `SENTRY_API_KEY`, `SENTRY_AUTH_TOKEN`, `SENTRY_ORG_SLUG`, `SENTRY_PROJECT_SLUG`, and `SENTRY_DSYM_PATH`.

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

For some more detailed help with plugins problems, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Plugins.md) in the main `fastlane` repo.

## About `fastlane`

`fastlane` automates building, testing, and releasing your app for beta and app store distributions. To learn more about `fastlane`, check out [fastlane.tools](https://fastlane.tools).
