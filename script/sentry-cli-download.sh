#!/bin/bash

props_file="script/sentry-cli.properties"

function prop {
  grep "$1" $props_file | cut -d'=' -f2 | xargs
}

base_url="$(prop 'repo')/releases/download/$(prop 'version')"
platforms=(Darwin-universal Linux-i686 Linux-x86_64 Windows-i686.exe Windows-x86_64.exe)
target_dir="bin"

for platform in "${platforms[@]}"
do
  download_url=$base_url/sentry-cli-$platform
  target_file="$target_dir/sentry-cli-$platform"

  echo "$download_url"
  echo "$target_file"

  rm -f target_file

  curl -SL --progress-bar "$download_url" -o "$target_file"
  chmod +x "$target_file"
done
