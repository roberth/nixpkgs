{ stdenv, fetchFromGitHub
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2, icu
, languageMachines
}:

stdenv.mkDerivation {
  name = "frogdata";
  version = "0.13";
  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "frogdata";
    rev = "3c6fed5ef4dab3e394622f4894b629e84ecd136b";
    sha256 = "1y4jqgilpg78rk1nvims3h5sn3q7jqyppadyn14zaq12ry6wyykz";
  };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive
                ];

  preConfigure = ''
    sh bootstrap.sh
  '';

  meta = with stdenv.lib; {
    description = "Data for Frog, a Tagger-Lemmatizer-Morphological-Analyzer-Dependency-Parser for Dutch";
    homepage    = https://languagemachines.github.io/frog;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];
  };

}
