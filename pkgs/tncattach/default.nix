{ lib, stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "tncattach";
  version = "0.1.9";

  src = fetchgit {
    url = "https://github.com/markqvist/tncattach";
    rev = "bb9ff10158c04a37cb3221152885a083e3059909";
    sha256 = "0n7ad4gqvpgabw2i67s51lfz386wmv0cvnhxq9ygxpsqmx9aynxk";
  };

  nativeBuildInputs = [  ];

  installPhase = ''
    mkdir -p $out/bin
    cp tncattach $out/bin
    install -D -m 644 tncattach.8 $out/share/man/man8/tncattach.8
  '';

  meta = with lib; {
    description = "Attach KISS TNC devices as network interfaces";
    homepage = "https://github.com/markqvist/tncattach";
    license = licenses.mit;
    maintainers =  with maintainers; [ sarcasticadmin ];
    platforms = platforms.unix;
  };
}
