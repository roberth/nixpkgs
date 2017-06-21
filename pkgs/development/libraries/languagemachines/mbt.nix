{ stdenv, fetchFromGitHub
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2
, languageMachines
}:

stdenv.mkDerivation {
  name = "mbt";
  version = "3.2.16";
  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "mbt";
    rev = "599726a58e562cbe07052b456007047abcd795db";
    sha256 = "0ki7dcjmyj0l4sky1paphhqcdmrkh37pc8qnj4nkgh0bd0ny3wiv";
  };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive
                  libxml2
                  languageMachines.ticcutils
                  languageMachines.timbl
                ];
  patches = [ ./mbt-add-libxml2-dep.patch ];
  preConfigure = ''
    sh bootstrap.sh
  '';

  meta = with stdenv.lib; {
    description = "Memory Based Tagger";
    homepage    = https://languagemachines.github.io/mbt/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      MBT is a memory-based tagger-generator and tagger in one. The tagger-generator part can generate a sequence tagger on the basis of a training set of tagged sequences; the tagger part can tag new sequences. MBT can, for instance, be used to generate part-of-speech taggers or chunkers for natural language processing. It has also been used for named-entity recognition, information extraction in domain-specific texts, and disfluency chunking in transcribed speech.

      Mbt is used by Frog for Dutch tagging.
    '';
  };

}
