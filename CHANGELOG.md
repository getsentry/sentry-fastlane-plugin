# Changelog

## 1.12.2

### Fixes

- fix: Return output from `call_sentry_cli` to allow parsing in `fallback_sentry_cli_auth` (#140)

## 1.12.1

### Fixes

- fix: Prevent buffers deadlock by merging stdout and stderr (#138)

## 1.12.0

### Features

- feat: Add sentry cli path as parameter for actions (#97)

### Fixes

- Add missing mac supported platform to `sentry_upload_dsym` (#115)

## 1.11.1

### Fixes

- fix: Bug in upload process (#109)
- fix: Correct link to sentry docs in action description (#104)

## 1.11.0

We bumped the minimum sentry-cli version to `1.70.1` because it includes an essential fix for hanging dSYMs uploads.

### Fixes

- fix: Hanging dSYMs upload by setting min sentry-cli version to 1.70.1 (#102)

## 1.10.1

### Fixes

- fix: Upload Dif use '-' instead of '_' ([#99](https://github.com/getsentry/sentry-fastlane-plugin/pull/99))

## 1.10.0

### Features

- feat: Add default value `.` for path param of `sentry_upload_dif` action ([#94](https://github.com/getsentry/sentry-fastlane-plugin/pull/94))
- feat: Add an action to check sentry-cli is installed([#78](https://github.com/getsentry/sentry-fastlane-plugin/pull/78))

### Fixes

- fix: sets `--finalize` CLI parameter when `finalize` option is set to `true` ([#40](https://github.com/getsentry/sentry-fastlane-plugin/pull/40))

## 1.9.0

### Features

- Add sentry-cli upload-dif action ([#89](https://github.com/getsentry/sentry-fastlane-plugin/pull/89))
- Support build numbers in versions ([#90](https://github.com/getsentry/sentry-fastlane-plugin/pull/90))

### Fixes

- Don't push value to non-value param for upload-sourcemaps ([#92](https://github.com/getsentry/sentry-fastlane-plugin/pull/92))

## 1.8.3

### Fixes

- Print sentry-cli level debug when verbose is set ([#88](https://github.com/getsentry/sentry-fastlane-plugin/pull/88))
- Fix action to allow stripping prefix ([#87](https://github.com/getsentry/sentry-fastlane-plugin/pull/87))

## 1.8.2

### Features

- Add Sentry Create Deploy Action ([#83](https://github.com/getsentry/sentry-fastlane-plugin/pull/83))
