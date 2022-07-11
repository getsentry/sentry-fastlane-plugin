#!/bin/bash

props_file="script/sentry-cli.properties"

function prop {
  grep "$1" $props_file | cut -d'=' -f2 | xargs
}

base_url="$(prop 'repo')/releases/download/$(prop 'version')"
target_dir="bin/"

rm -f $target_dir/sentry-cli
download_url=$base_url//sentry-cli-Darwin-universal
fn="$target_dir/sentry-cli"
curl -SL --progress-bar "$download_url" -o "$fn"
chmod +x "$fn"
