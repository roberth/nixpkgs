{ stdenv, fetchFromGitHub
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2
, languageMachines
}:

stdenv.mkDerivation {
  name = "timbl";
  version = "6.4.9";
  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "timbl";
    rev = "c0df5e3868068e4b713ea20aa10f356a79c9a2c6";
    sha256 = "121ry4vrpscjp9ls45sk4c1v6r83f4ln3w8yr1qrnwrr40v3y67a";
  };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive
                  libxml2
                  languageMachines.ticcutils
                ];
  preConfigure = "sh bootstrap.sh";

  meta = with stdenv.lib; {
    description = "TiMBL implements several memory-based learning algorithms";
    homepage    = https://github.com/LanguageMachines/timbl/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      TiMBL is an open source software package implementing several memory-based learning algorithms, among which IB1-IG, an implementation of k-nearest neighbor classification with feature weighting suitable for symbolic feature spaces, and IGTree, a decision-tree approximation of IB1-IG. All implemented algorithms have in common that they store some representation of the training set explicitly in memory. During testing, new cases are classified by extrapolation from the most similar stored cases.

      For over fifteen years TiMBL has been mostly used in natural language processing as a machine learning classifier component, but its use extends to virtually any supervised machine learning domain. Due to its particular decision-tree-based implementation, TiMBL is in many cases far more efficient in classification than a standard k-nearest neighbor algorithm would be.
    '';
  };

}
