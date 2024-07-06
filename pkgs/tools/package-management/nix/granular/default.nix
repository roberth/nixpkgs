{ lib, callPackage, newScope, stdenv, src, version }:

let
  # A new scope, so that we can use `callPackage` to inject our own interdependencies
  # without "polluting" the top level "`pkgs`" attrset.
  # This also has the benefit of providing us with a distinct set of packages
  # we can iterate over.
  nixComponents = lib.makeScope nixDependencies.newScope (import ./packaging/components.nix);

  # The dependencies are in their own scope, so that they don't have to be
  # in Nixpkgs top level `pkgs` or `nixComponents`.
  nixDependencies = lib.makeScope newScope (callPackage ./dependencies.nix {
    inherit src version stdenv;
  });

  # The `nix` component isn't built with meson yet.
  # TODO remove removeNix
  removeNix = c: lib.removeAttrs c ["nix"];

in
  removeNix nixComponents
