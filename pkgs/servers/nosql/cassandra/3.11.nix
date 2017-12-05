{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.11.1";
  sha256 = "6feed696759e2f3219e0ebde13f4c9080cac0744a77eb3cb43af136ab527f0ed";
})
