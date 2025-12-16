#!/usr/bin/env bash

platform=''

while [[ "$1" != "--" && -n "$1" ]]; do
  [ -z "$platform" ] && platform="$1"
  shift
done

[ -z "$platform" ] && platform="x86_64-linux"
build_platform="${platform%-*}-linux" # We only build linux

if [[ "$1" == "--" ]]; then
  shift
fi

directory="$(realpath "$(dirname "$0")")"
sanitize="${directory}/sanitize-dotfiles.sh"
root="$(dirname "$directory")"

echo '>>> Building flake:'
rm -rf output
mkdir output
nix build "${root}#packages.${build_platform}.m3l6h-tmux-build-dotfiles" "$@"
result="$(realpath "${root}/result")"
"${result}/bin/nixos-test-driver"
"$sanitize" 'output' "$platform"

echo '>>> Successfully built dotfiles'
