{ stdenv, fetchFromGitHub
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2, icu
, languageMachines
}:

stdenv.mkDerivation {
  name = "ucto";
  version = "0.9.6";
  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "ucto";
    rev = "f70ea2843c978d3d8dc1b37a97400f5431b471cb";
    sha256 = "0hc441862yhqivcfl8pmb7ry4w8kyg8m1skasbh7r7rpy5w3hm0c";
  };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive
                  icu libxml2
                  languageMachines.ticcutils
                  languageMachines.libfolia
                  languageMachines.uctodata
                  # TODO textcat from libreoffice? Pulls in X11 dependencies?
                ];
  preConfigure = "sh bootstrap.sh;";

  postInstall = ''
    # ucto expects the data files installed in the same prefix
    mkdir -p $out/share/ucto/;
    for f in ${languageMachines.uctodata}/share/ucto/*; do
      echo "Linking $f"
      ln -s $f $out/share/ucto/;
    done;
  '';

  meta = with stdenv.lib; {
    description = "A rule-based tokenizer for natural language";
    homepage    = https://languagemachines.github.io/ucto/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      Ucto tokenizes text files: it separates words from punctuation, and splits sentences. It offers several other basic preprocessing steps such as changing case that you can all use to make your text suited for further processing such as indexing, part-of-speech tagging, or machine translation.

      Ucto comes with tokenisation rules for several languages and can be easily extended to suit other languages. It has been incorporated for tokenizing Dutch text in Frog, a Dutch morpho-syntactic processor.
    '';
  };

}
