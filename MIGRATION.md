# Migrating from sentry-fastlane-plugin v2 to v3

Version 3 of the plugin replaces the legacy Rust `sentry-cli` (v3) with the new [Sentry CLI](https://github.com/getsentry/cli) (the `sentry` binary, documented at [cli.sentry.dev](https://cli.sentry.dev)). The actions keep their names and, with a few exceptions listed below, their parameters.

## How the CLI is installed

The legacy `sentry-cli` was bundled inside the gem. The new CLI ships as a standalone binary of roughly 100 MB per platform, so bundling all of them is no longer practical. Instead the plugin:

1. Pins a Sentry CLI version in `lib/fastlane/plugin/sentry/sentry-cli.json`, together with the SHA-256 checksum of every release asset.
2. Downloads the asset for the current host from GitHub Releases the first time an action runs.
3. Verifies the checksum, extracts the binary and caches it in `~/.cache/sentry-fastlane-plugin/sentry-cli/<version>/` (`$XDG_CACHE_HOME` and `%LOCALAPPDATA%` are honored). Later runs reuse the cached binary without any network access.

Things to be aware of:

- **Network access on first run.** The machine running fastlane needs HTTPS access to `github.com` and `objects.githubusercontent.com` once per plugin version. Proxies configured through `http_proxy` / `https_proxy` are honored.
- **Custom cache location.** Set `SENTRY_FASTLANE_PLUGIN_CACHE_DIR` to change where the CLI is stored. On CI this lets you cache the directory between runs (the integration test workflow in this repository shows an example using `actions/cache`).
- **Offline or restricted environments.** Install the Sentry CLI yourself (`curl -fsSL https://cli.sentry.dev/install | bash`, `brew install getsentry/tools/sentry` or `npm install -g sentry`) and point the plugin at it with `sentry_cli_path: '/path/to/sentry'` or the `SENTRY_CLI_PATH` environment variable. The binary must be at least the version pinned by the plugin.
- **Supported hosts.** macOS (Apple silicon and Intel), Linux (x86_64 and arm64, glibc) and Windows (x86_64). 32-bit Linux and Windows hosts are no longer supported because the new CLI does not provide binaries for them.
- **License.** The Sentry CLI is licensed under the [FSL-1.1-Apache-2.0](https://github.com/getsentry/cli/blob/main/LICENSE.md) license, not the MIT license of this plugin. See the `LICENSE` file.

## Custom `sentry_cli_path`

`sentry_cli_path` (and `SENTRY_CLI_PATH`) must now point to the new `sentry` binary. Pointing it at a legacy `sentry-cli` executable fails with an error, because the legacy CLI does not understand the commands the plugin now runs. Remove the parameter to use the version managed by the plugin, or install the new CLI as described above.

## Authentication and configuration

Nothing changes for the common case: `auth_token`, `org_slug`, `project_slug`, `url` and `log_level` keep working and are passed to the CLI through the same `SENTRY_AUTH_TOKEN`, `SENTRY_ORG`, `SENTRY_PROJECT`, `SENTRY_URL` and `SENTRY_LOG_LEVEL` environment variables. `.sentryclirc` files are still read by the new CLI when no `auth_token` is given.

## Parameter changes per action

### `sentry_upload_sourcemap`

This action is affected the most, because `sentry sourcemap upload` works differently from `sentry-cli sourcemaps upload`:

- **`sourcemap` takes directories.** The new CLI scans one directory for JavaScript files and their sourcemaps instead of accepting individual files. Pass the directory (or an array of directories) that contains your bundle and its `.map` file. Each directory is uploaded in a separate CLI invocation.

  ```ruby
  # Before
  sentry_upload_sourcemap(
    version: '1.0.0',
    sourcemap: ['main.jsbundle', 'main.jsbundle.map']
  )

  # After
  sentry_upload_sourcemap(
    version: '1.0.0',
    sourcemap: 'build/sourcemaps',   # directory containing main.jsbundle and main.jsbundle.map
    ext: ['jsbundle']                # see below
  )
  ```

- **Default extensions changed.** The CLI now only considers `.js`, `.cjs` and `.mjs` files by default. React Native bundles (`.jsbundle`, `.bundle`) need `ext: ['jsbundle', 'bundle']`.
- **`ext` and `ignore` are joined with commas** before being passed to the CLI, because the new CLI accepts each flag only once. Glob patterns containing commas cannot be expressed anymore.
- **Removed options** (still accepted, but ignored with a deprecation warning): `url_suffix`, `note`, `validate`, `decompress`, `wait`, `wait_for`, `no_sourcemap_reference`, `debug_id_reference`, `bundle`, `bundle_sourcemap` and `strict`. The CLI now always uses the debug ID of the linked sourcemap, which is what `debug_id_reference` used to enable.

### `sentry_upload_build`

- `dsym_path` inputs are still uploaded with `debug-files upload` for event symbolication, but they are **no longer attached to the IPA build upload** (`--dsym`), because the new CLI does not support that flag yet.

### `sentry_debug_files_upload`

- `symbol_maps` is ignored with a deprecation warning. BCSymbolMap resolution only applied to Apple Bitcode, which Apple has deprecated.

### `sentry_set_commits`

- `ignore_missing` is ignored with a deprecation warning. The new CLI has no `--ignore-missing` flag.

### `sentry_upload_proguard`

- `write_properties` is ignored with a deprecation warning. The new CLI has no `--write-properties` flag.

### `sentry_create_release`, `sentry_finalize_release`, `sentry_create_deploy`, `sentry_upload_snapshots`, `sentry_check_cli_installed`

No parameter changes. `sentry_create_deploy` still requires `env`.

## Commands run by each action

For reference, these are the CLI commands the actions now run:

| Action                      | v2 (`sentry-cli`)                            | v3 (`sentry`)                                       |
| --------------------------- | -------------------------------------------- | --------------------------------------------------- |
| `sentry_debug_files_upload` | `debug-files upload`                         | `debug-files upload`                                |
| `sentry_upload_build`       | `build upload`                               | `build upload`                                      |
| `sentry_create_release`     | `releases new`                               | `release create`                                    |
| `sentry_finalize_release`   | `releases finalize`                          | `release finalize`                                  |
| `sentry_set_commits`        | `releases set-commits`                       | `release set-commits`                               |
| `sentry_create_deploy`      | `releases deploys <version> new --env <env>` | `release deploy <version> <env>`                    |
| `sentry_upload_sourcemap`   | `sourcemaps upload <files...>`               | `sourcemap upload <directory>` (once per directory) |
| `sentry_upload_proguard`    | `upload-proguard`                            | `proguard upload`                                   |
| `sentry_upload_snapshots`   | `snapshots upload`                           | `snapshots upload`                                  |

See the Sentry CLI's own [migration guide](https://cli.sentry.dev/migrating-from-v3/) for details on the CLI level changes.
