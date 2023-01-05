{ lib, stdenv, fetchgit, perl}:
#with (import <nixpkgs> {});

stdenv.mkDerivation rec {
  pname = "aprx-unstable";
  version = "2021-06-01";

  src = fetchgit {
    url = "https://github.com/PhirePhly/aprx";
    rev = "13c6e7950210c501f71a0d12bb5c780f37e21b9b";
    sha256 = "1g6di35r3l4vwarrfaymhf3qhyzd399dn3hnya6ydccph4np61x0";
  };

  nativeBuildInputs = [  ];

  buildInputs = [ perl ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp aprx $out/bin
    install -D -m 644 aprx.8 $out/share/man/man8/aprx.8
  '';

  CFLAGS="-fcommon -O2";

  meta = with lib; {
    description = "A multitalented APRS i-gate / digipeater";
    homepage = "http://thelifeofkenneth.com/aprx";
    license = licenses.bsd3;
    maintainers =  with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
}
