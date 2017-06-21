{ stdenv, fetchFromGitHub
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2, icu
, languageMachines }:

stdenv.mkDerivation {
  name = "libfolia";
  version = "1.7";
  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "libfolia";
    rev = "450cbccc99c9733fe7671a64d987479661b49398";
    sha256 = "0znhg74fcvxr8cvjz7i3d6cdzkpfhdlc298dckybyzwc6slrfzvw";
  };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive libxml2 icu languageMachines.ticcutils ];
  preConfigure = "sh bootstrap.sh";

  meta = with stdenv.lib; {
    description = "A C++ API for FoLiA documents; an XML-based linguistic annotation format.";
    homepage    = https://proycon.github.io/folia/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      A high-level C++ API to read, manipulate, and create FoLiA documents. FoLiA is an XML-based annotation format, suitable for the representation of linguistically annotated language resources. FoLiA’s intended use is as a format for storing and/or exchanging language resources, including corpora.
    '';
  };

}
