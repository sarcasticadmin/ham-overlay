{ lib
, stdenv
, fetchzip
}:
stdenv.mkDerivation rec {
  pname = "wwl";

  version = "1.3";

  src = fetchzip {
    url = "http://www.db.net/downloads/wwl+db-1.3.tgz";
    sha256 = "sha256-kOW4znD6IobcHAaaIiebfqI662OQZoc07La52ckxo1s=";
  };

  makeFlags = [ "PREFIX=$(out)" "MANPREFIX=$(out)/man" ];

  preInstall = ''
    mkdir -p $out/bin $out/man/man1
  '';

  meta = with lib; {
    description = "Maidenhead locator utility";
    homepage = "http://www.db.net/downloads/";
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
}
