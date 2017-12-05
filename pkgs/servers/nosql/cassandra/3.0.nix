{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.0.15";
  sha256 = "af340e40987abad15b600438acea2521586bab4f5c72f914c981d457eee522d9";
})
