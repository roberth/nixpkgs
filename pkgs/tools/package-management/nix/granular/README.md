# Nix vendored files

This directory contains Nix expressions that are vendored from the Nixpkgs repository.
Their directory structure is preserved so that the upstream files can be used verbatim.

All path expressions (`./.`, `./data` etc) are consumed through functions that are implemented differently here vs upstream.
Our implementation here treat all path values as "virtual" paths, so it is ok that they don't point to real locations.
See [`./dependencies.nix`](./dependencies.nix) for the implementation details.
See [`./update.sh`](./update.sh) for the script that updates the vendored files.

TODO: handle multiple Nix versions.
