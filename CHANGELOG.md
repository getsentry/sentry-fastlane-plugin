# Changelog

## Unreleased

### Features

- Add `sentry upload build` action to upload iOS app archives (.xcarchive) to Sentry [#320](https://github.com/getsentry/sentry-fastlane-plugin/pull/320)
- Add git context parameters to `sentry_upload_build` action for enhanced context including commit SHAs, branch names, repository information, and pull request details [#335](https://github.com/getsentry/sentry-fastlane-plugin/pull/335)
- Add environment variable support for git parameters in `sentry_upload_build` action (SENTRY_HEAD_SHA, SENTRY_BASE_SHA, SENTRY_VCS_PROVIDER, SENTRY_HEAD_REPO_NAME, SENTRY_BASE_REPO_NAME, SENTRY_HEAD_REF, SENTRY_BASE_REF, SENTRY_PR_NUMBER, SENTRY_BUILD_CONFIGURATION) [#342](https://github.com/getsentry/sentry-fastlane-plugin/pull/342)

### Dependencies

- Bump CLI from v2.51.0 to v2.55.0 ([#331](https://github.com/getsentry/sentry-fastlane-plugin/pull/331), [#334](https://github.com/getsentry/sentry-fastlane-plugin/pull/334), [#343](https://github.com/getsentry/sentry-fastlane-plugin/pull/343), [#344](https://github.com/getsentry/sentry-fastlane-plugin/pull/344))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2550)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.51.0...2.55.0)

## 1.33.0

### Dependencies

- Bump CLI from v2.50.0 to v2.51.0 ([#328](https://github.com/getsentry/sentry-fastlane-plugin/pull/328))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2510)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.50.0...2.51.0)

## 1.32.0

### Dependencies

- Bump CLI from v2.47.0 to v2.50.0 ([#325](https://github.com/getsentry/sentry-fastlane-plugin/pull/325))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2500)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.47.0...2.50.0)

## 1.31.0

### Dependencies

- Bump CLI from v2.46.0 to v2.47.0 ([#323](https://github.com/getsentry/sentry-fastlane-plugin/pull/323))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2470)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.46.0...2.47.0)

## 1.30.0

### Dependencies

- Bump CLI from v2.43.0 to v2.46.0 ([#314](https://github.com/getsentry/sentry-fastlane-plugin/pull/314), [#317](https://github.com/getsentry/sentry-fastlane-plugin/pull/317), [#319](https://github.com/getsentry/sentry-fastlane-plugin/pull/319))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2460)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.43.0...2.46.0)

## 1.29.0

### Dependencies

- Bump CLI from v2.42.4 to v2.43.0 ([#309](https://github.com/getsentry/sentry-fastlane-plugin/pull/309))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2430)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.42.4...2.43.0)

## 1.28.1

### Dependencies

- Bump CLI from v2.42.2 to v2.42.4 ([#305](https://github.com/getsentry/sentry-fastlane-plugin/pull/305), [#306](https://github.com/getsentry/sentry-fastlane-plugin/pull/306))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2424)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.42.2...2.42.4)

## 1.28.0

### Dependencies

- Bump CLI from v2.41.1 to v2.42.2 ([#303](https://github.com/getsentry/sentry-fastlane-plugin/pull/303))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2422)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.41.1...2.42.2)

## 1.27.1

### Dependencies

- Bump CLI from v2.41.0 to v2.41.1 ([#294](https://github.com/getsentry/sentry-fastlane-plugin/pull/294))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2411)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.41.0...2.41.1)

## 1.27.0

### Dependencies

- Bump CLI from v2.40.0 to v2.41.0 ([#293](https://github.com/getsentry/sentry-fastlane-plugin/pull/293))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2410)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.40.0...2.41.0)

## 1.26.0

### Dependencies

- Bump CLI from v2.36.3 to v2.40.0 ([#286](https://github.com/getsentry/sentry-fastlane-plugin/pull/286))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2400)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.36.3...2.40.0)

With this change, the force-foreground flag is no longer needed, since we always upload in the foreground. The flag is now a deprecated no-op.

## 1.25.1

### Dependencies

- Bump CLI from v2.36.1 to v2.36.3 ([#271](https://github.com/getsentry/sentry-fastlane-plugin/pull/271))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2363)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.36.1...2.36.3)

## 1.25.0

### Dependencies

- Bump CLI from v2.33.0 to v2.36.1 ([#269](https://github.com/getsentry/sentry-fastlane-plugin/pull/269))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2361)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.33.0...2.36.1)

## 1.24.0

### Dependencies

- Bump CLI from v2.32.1 to v2.33.0 ([#264](https://github.com/getsentry/sentry-fastlane-plugin/pull/264))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2330)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.32.1...2.33.0)

## 1.23.0

### Dependencies

- Bump CLI from v2.31.2 to v2.32.1 ([#261](https://github.com/getsentry/sentry-fastlane-plugin/pull/261))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2321)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.31.2...2.32.1)

## 1.22.1

### Dependencies

- Bump CLI from v2.31.0 to v2.31.2 ([#258](https://github.com/getsentry/sentry-fastlane-plugin/pull/258))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2312)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.31.0...2.31.2)

## 1.22.0

### Features

- Add option to control the log output ([#253](https://github.com/getsentry/sentry-fastlane-plugin/pull/253))

### Dependencies

- Bump CLI from v2.30.4 to v2.31.0 ([#252](https://github.com/getsentry/sentry-fastlane-plugin/pull/252))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2310)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.30.4...2.31.0)

## 1.21.0

### Dependencies

- Bump CLI from v2.29.1 to v2.30.4 ([#250](https://github.com/getsentry/sentry-fastlane-plugin/pull/250))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2304)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.29.1...2.30.4)

## 1.20.0

### Features

- Replace `upload-dif`/`upload-dsym` with `debug-files upload`(#234)

### Dependencies

- Bump CLI from v2.28.6 to v2.29.1 ([#246](https://github.com/getsentry/sentry-fastlane-plugin/pull/246))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2291)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.28.6...2.29.1)

## 1.19.0

### Dependencies

- Bump CLI from v2.25.3 to v2.28.6 ([#237](https://github.com/getsentry/sentry-fastlane-plugin/pull/237), [#243](https://github.com/getsentry/sentry-fastlane-plugin/pull/243))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2286)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.25.3...2.28.6)

## 1.18.0

### Fixes

- Don't upload code source if "include_source" is false (#231)

### Dependencies

- Bump CLI from v2.23.0 to v2.25.3 ([#236](https://github.com/getsentry/sentry-fastlane-plugin/pull/236))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2253)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.23.0...2.25.3)

## 1.17.0

### Dependencies

- Bump CLI from v2.21.2 to v2.23.0 ([#218](https://github.com/getsentry/sentry-fastlane-plugin/pull/218), [#219](https://github.com/getsentry/sentry-fastlane-plugin/pull/219), [#221](https://github.com/getsentry/sentry-fastlane-plugin/pull/221), [#222](https://github.com/getsentry/sentry-fastlane-plugin/pull/222), [#223](https://github.com/getsentry/sentry-fastlane-plugin/pull/223))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2230)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.21.2...2.23.0)

## 1.16.0

### Features

- Bump CLI from v2.10.0 to v2.21.2 ([#185](https://github.com/getsentry/sentry-fastlane-plugin/pull/185), [#187](https://github.com/getsentry/sentry-fastlane-plugin/pull/187), [#188](https://github.com/getsentry/sentry-fastlane-plugin/pull/188), [#198](https://github.com/getsentry/sentry-fastlane-plugin/pull/198), [#211](https://github.com/getsentry/sentry-fastlane-plugin/pull/211), [#214](https://github.com/getsentry/sentry-fastlane-plugin/pull/214))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2212)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.10.0...2.21.2)

### Dependencies

## 1.15.0

### Features

- Bump CLI from v2.7.0 to v2.10.0 ([#173](https://github.com/getsentry/sentry-fastlane-plugin/pull/173), [#175](https://github.com/getsentry/sentry-fastlane-plugin/pull/175), [#178](https://github.com/getsentry/sentry-fastlane-plugin/pull/178), [#181](https://github.com/getsentry/sentry-fastlane-plugin/pull/181))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#2100)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.7.0...2.10.0)
- Support multiple paths in `upload_dif` command (#177)
- `set_commits` supports `--ignore missing` ([#180](https://github.com/getsentry/sentry-fastlane-plugin/pull/180))

## 1.14.0

### Features

- Bump CLI from v2.5.2 to v2.7.0 ([#167](https://github.com/getsentry/sentry-fastlane-plugin/pull/167), [#170](https://github.com/getsentry/sentry-fastlane-plugin/pull/170))
  - [changelog](https://github.com/getsentry/sentry-cli/blob/master/CHANGELOG.md#270)
  - [diff](https://github.com/getsentry/sentry-cli/compare/2.5.2...2.7.0)

### Fixes

- No such file or directory (#168)

## 1.13.1

### Fixes

- fix: Bundle correct sentry-cli os/arch (#164)

## 1.13.0

### Features

- Enha: Pin/Bundle sentry-cli Version (#143)
- Bump CLI from v1.72.0 to v2.5.2 (#158)
- Enha: Support uploading multiple source map files simultaneously (#151)

## 1.12.3

### Fixes

- fix: Use threads to read `sentry-cli` output (#147)

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
