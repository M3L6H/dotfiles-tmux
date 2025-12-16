#!/usr/bin/env bash

version="$1"

directory="$(realpath "$(dirname "$0")")"
root="$(dirname "$directory")"

if [ -z "$version" ]; then
  version="$(perl -ne 'print "v$1" if /(?:version = ")([^"]+)/' "${root}/flake.nix")"
else
  perl -i -pe "s|version = \".*\"|version = \"${version#v}\"|g" "${root}/flake.nix"
  git add --all
  git commit -m "release: ${version}"
fi

git tag -a "$version" -m "release: ${version}"

git push origin --all && git push origin --tags
