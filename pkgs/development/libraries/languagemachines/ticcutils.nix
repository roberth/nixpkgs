{ stdenv, fetchFromGitHub
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2, zlib, bzip2, libtar }:

stdenv.mkDerivation {
  name = "ticcutils";
  version = "0.15";
  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "ticcutils";
    rev = "4ff699279b33b81970307814004612873c6d032d";
    sha256 = "078s32w6004nyl8z21cl3mvz0v20n2bf497nkxb35j4rdjiybqyp";
  };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive libxml2
                  # optional:
                  zlib bzip2 libtar
                  # broken but optional: boost
                ];
  preConfigure = "sh bootstrap.sh";

  meta = with stdenv.lib; {
    description = "This module contains useful functions for general use in the TiCC software stack and beyond.";
    homepage    = https://github.com/LanguageMachines/ticcutils;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];
  };

}
