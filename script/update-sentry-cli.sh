#!/bin/bash
# Regenerates lib/fastlane/plugin/sentry/sentry-cli.json from script/sentry-cli.properties.
#
# The plugin does not bundle the Sentry CLI anymore. Instead it downloads the pinned
# version on first use and verifies the download against the SHA-256 checksums
# recorded in the manifest written by this script.
#
# Usage: script/update-sentry-cli.sh
# (the dependency updater also passes "<old version> <new version>", which are ignored)
set -euo pipefail

cd "$(dirname "$0")/.."

props_file="script/sentry-cli.properties"
manifest_file="lib/fastlane/plugin/sentry/sentry-cli.json"

prop() {
  grep "^$1" "$props_file" | cut -d'=' -f2 | xargs
}

version="$(prop 'version')"
repo="$(prop 'repo')"
base_url="$repo/releases/download/$version"

# Keep in sync with Fastlane::Helper::SentryCliInstaller.asset_name
assets=(
  sentry-darwin-arm64.gz
  sentry-darwin-x64.gz
  sentry-linux-arm64.gz
  sentry-linux-x64.gz
  sentry-windows-x64.exe.gz
)

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

sha256() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

echo "Generating $manifest_file for Sentry CLI $version"
{
  echo "{"
  echo "  \"version\": \"$version\","
  echo "  \"repo\": \"$repo\","
  echo "  \"assets\": {"
  last_index=$((${#assets[@]} - 1))
  for i in "${!assets[@]}"; do
    asset="${assets[$i]}"
    url="$base_url/$asset"
    echo "Downloading $url" >&2
    curl -fsSL --retry 3 "$url" -o "$tmp_dir/$asset"
    checksum="$(sha256 "$tmp_dir/$asset")"
    separator=","
    [ "$i" -eq "$last_index" ] && separator=""
    echo "    \"$asset\": \"$checksum\"$separator"
  done
  echo "  }"
  echo "}"
} > "$manifest_file.tmp"
mv "$manifest_file.tmp" "$manifest_file"

echo "Wrote $manifest_file:"
cat "$manifest_file"
