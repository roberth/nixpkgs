{ stdenv, fetchFromGitHub
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2, icu
, languageMachines }:

stdenv.mkDerivation {
  name = "uctodata";
  version = "0.4";
  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "uctodata";
    rev = "97584ee05b3389aa3db1308b14a895d7929f0a45";
    sha256 = "06f9vdp27khbs84kjbhsjkwyy50ks9n4h6vaqh33dy56jiqn5zz0";
  };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive
                  
                ];
  preConfigure = "sh bootstrap.sh";

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
