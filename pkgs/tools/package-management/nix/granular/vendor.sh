#!/usr/bin/env nix
#!nix shell nixpkgs/nixos-24.05#bash --command bash
# This vendors the required packaging files from a nix clone, as Nixpkgs can't
# import from remote sources for valid performance reasons.

set -euo pipefail
echo "+ cd $(dirname "${BASH_SOURCE[0]}")"
cd "$(dirname "${BASH_SOURCE[0]}")"

nixpkgs="$(realpath ../../../../..)"
nix="$(realpath $nixpkgs/../nix)"

# check that $nix looks like a Nix checkout
(
  set -x
  [[ -f "$nix/.version" ]]
  [[ -f "$nix/flake.nix" ]]
  [[ -d "$nix/src" ]]
) || {
  echo "error: The path $nix does not look like it contains the Nix sources."
  echo "       This script assumes nix and nixpkgs are siblings on your file system."
  exit 1
}

mkdir -p packaging
cp $nix/packaging/components.nix ./packaging/
find $nix -name package.nix -mindepth 2 | while read f; do
  case $f in
    *.git/*) break; ;;
    *.worktree/*) break; ;;
  esac
  rel=$(realpath --relative-to $nix $f)
  reldir=$(dirname $rel)
  (
    set -x
    mkdir -p $reldir
    cp $nix/$rel $rel
  )
done
