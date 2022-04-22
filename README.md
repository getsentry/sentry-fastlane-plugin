<p align="center">
    <a href="https://sentry.io" target="_blank" align="center">
        <img src="https://sentry-brand.storage.googleapis.com/sentry-logo-black.png" width="280">
    </a>
<br/>
    <h1>Sentry Fastlane Plugin</h1>
</p>

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-sentry)
[![Tests](https://img.shields.io/github/workflow/status/getsentry/sentry-fastlane/test?label=Tests)](https://github.com/getsentry/sentry-fastlane/actions?query=workflow%3A"test")
[![Gem Version](https://badge.fury.io/rb/fastlane-plugin-sentry.svg)](https://badge.fury.io/rb/fastlane-plugin-sentry)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with fastlane-plugin-sentry, add it to your project by running:

```bash
fastlane add_plugin sentry
```

## Sentry Actions

A subset of actions provided by the CLI: https://docs.sentry.io/learn/cli/

### Authentication & Configuration

`auth_token` is the preferred way to authentication method with Sentry. This can be obtained on https://sentry.io/api/.
`api_key` still works but will eventually become deprecated. This can be obtained through the settings of your project.
Also note that as of version `1.2.0` you no longer have to provide the required parameters, we will try to fallback to your `.sentryclirc` config file if possible.

The following environment variables may be used in place of parameters: `SENTRY_API_KEY`, `SENTRY_AUTH_TOKEN`, `SENTRY_ORG_SLUG`, and `SENTRY_PROJECT_SLUG`.

### Uploading Debug Information Files

```ruby
sentry_upload_dif(
  api_key: '...', # Do not use if using auth_token
  auth_token: '...', # Do not use if using api_key
  org_slug: '...',
  project_slug: '...',
  path: '/path/to/files', # Optional. We'll default to '.' when no value is provided.
)
```

The `SENTRY_DSYM_PATH` environment variable may be used in place of the `dsym_path` parameter.

Further options:

- __type__: Optional. Only consider debug information files of the given type. By default, all types are considered. Valid options: 'dsym', 'elf', 'breakpad', 'pdb', 'pe', 'sourcebundle', 'bcsymbolmap'.
- __no_unwind__: Optional. Do not scan for stack unwinding information. Specify this flag for builds with disabled FPO, or when stackwalking occurs on the device. This usually excludes executables and dynamic libraries. They might still be uploaded, if they contain additional processable information (see other flags)".
- __no_debug__: Optional. Do not scan for debugging information. This will usually exclude debug companion files. They might still be uploaded, if they contain additional processable information (see other flags)".
- __no_sources__: Optional. "Do not scan for source information. This will usually exclude source bundle files. They might still be uploaded, if they contain additional processable information (see other flags)".
- __ids__: Optional. Search for specific debug identifiers.
- __require_all__: Optional. Errors if not all identifiers specified with --id could be found.
- __symbol_maps__: Optional. Optional path to BCSymbolMap files which are used to resolve hidden symbols in dSYM files downloaded from iTunes Connect. This requires the dsymutil tool to be available.
- __derived_data__: Optional. Search for debug symbols in Xcode's derived data.
- __no_zips__: Do not search in ZIP files.
- __info_plist__: Optional. Optional path to the Info.plist. We will try to find this automatically if run from Xcode.  Providing this information will associate the debug symbols with a specific ITC application and build in Sentry.  Note that if you provide the plist explicitly it must already be processed.
- __no_reprocessing__: Optional. Do not trigger reprocessing after uploading.                           
- __force_foreground__: Optional. Wait for the process to finish. By default, the upload process will detach and continue in the background when triggered from Xcode.  When an error happens, a dialog is shown.  If this parameter is passed Xcode will wait for the process to finish before the build finishes and output will be shown in the Xcode build output.
- __include_sources__: Optional. Include sources from the local file system and upload them as source bundles.
- __wait__: Wait for the server to fully process uploaded files. Errors can only be displayed if --wait is specified, but this will significantly slow down the upload process.
- __upload_symbol_maps__: Optional. Upload any BCSymbolMap files found to allow Sentry to resolve hidden symbols, e.g. when it downloads dSYMs directly from App Store Connect or when you upload dSYMs without first resolving the hidden symbols using --symbol-maps.


Or the soon to be deprecated way:

```ruby
sentry_upload_dsym(
  api_key: '...', # Do not use if using auth_token
  auth_token: '...', # Do not use if using api_key
  org_slug: '...',
  project_slug: '...',
  symbol_maps: 'path to bcsymbols folder', # use this if you have a bcsymbols folder
  dsym_path: './App.dSYM.zip',
  info_plist: '...' # optional, sentry-cli tries to find the correct plist by itself
)
```

### Creating & Finalizing Releases

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

### Uploading Files & Sourcemaps

Useful for uploading build artifacts and JS sourcemaps for react-native apps built using fastlane.

```ruby
sentry_upload_file(
  api_key: '...',
  auth_token: '...',
  org_slug: '...',
  project_slug: '...',
  version: '...',
  app_identifier: '...', # pass in the bundle_identifer of your app
  build: '...', # Optionally pass in the build number of your app
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
  build: '...', # Optionally pass in the build number of your app
  dist: '...', # optional distribution of the release usually the buildnumber
  sourcemap: 'main.jsbundle.map', # sourcemap to upload
  rewrite: true
)
```

### Uploading Proguard Mapping File

```ruby
sentry_upload_proguard(
  api_key: '...', # Do not use if using auth_token
  auth_token: '...', # Do not use if using api_key
  org_slug: '...',
  project_slug: '...',
  android_manifest_path: 'path to merged AndroidManifest file', # found in `app/build/intermediates/manifests/full`
  mapping_path: 'path to mapping.txt to upload',
)
```

### Associating commits

Useful for telling Sentry which commits are associated with a release.

```ruby
sentry_set_commits(
  version: '...',
  app_identifier: '...', # pass in the bundle_identifer of your app
  build: '...', # Optionally pass in the build number of your app
  auto: false, # enable completely automated commit management
  clear: false, # clear all current commits from the release
  commit: '...', # commit spec, see `sentry-cli releases help set-commits` for more information
)
```

### Create deploy

Creates a new release deployment for a project on Sentry.

```ruby
sentry_create_deploy(
  api_key: '...', # Do not use if using auth_token
  auth_token: '...', # Do not use if using api_key
  org_slug: '...',
  project_slug: '...',
  version: '...',
  app_identifier: '...', # pass in the bundle_identifer of your app
  build: '...', # Optionally pass in the build number of your app
  env: 'staging', # The environment for this deploy. Required.
  name: '...', # Optional human readable name
  deploy_url: '...', # Optional URL that points to the deployment
  started: 1622630647, # Optional unix timestamp when the deployment started
  finished: 1622630700, # Optional unix timestamp when the deployment finished
  time: 180 # Optional deployment duration in seconds. This can be specified alternatively to `started` and `finished`
)
```

### Specify custom sentry-cli path

For every action, you can specify a custom sentry-cli path by adding `sentry_cli_path` to the action. This defaults to `which sentry-cli`.

### Checking the sentry-cli is installed

Useful for checking that the sentry-cli is installed and meets the minimum version requirements before starting to build your app in your lane.

```ruby
sentry_check_cli_installed()
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

For some more detailed help with plugins problems, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/) in the main `fastlane` repo.

## About `fastlane`

`fastlane` automates building, testing, and releasing your app for beta and app store distributions. To learn more about `fastlane`, check out [fastlane.tools](https://fastlane.tools).
