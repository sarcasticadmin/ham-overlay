{ lib
, stdenv
, fetchFromGitHub
, libax25
, which
}:
stdenv.mkDerivation rec {

  pname = "uronode";

  version = "2.15";

  src = fetchFromGitHub {
    owner = "sarcasticadmin";
    repo = "uronode";
    rev = "${version}";
    sha256 = "sha256-XuHlOGT5M9OWtSiqMKoqEYW9uc1+5JihzUSV9Il99vM=";
  };

  buildInputs = [ libax25 which ];

  env.NON_INTERACTIVE = "y";
  env.SBIN_DIR = "${placeholder "out"}/bin";
  env.BIN_DIR = "${placeholder "out"}/bin";
  env.MAN_DIR = "${placeholder "out"}/share/man";
  env.ETC_DIR = "${placeholder "out"}/share/uronode/example/etc";
  env.VAR_DIR = "${placeholder "out"}/share/uronode/doc";

  # ignore "make install" since it creates empty cruft in the drv
  installPhase = ''
    mkdir -p {$BIN_DIR,$SBIN_DIR,$MAN_DIR,$ETC_DIR,$VAR_DIR}
    make installbin installman installconf
  '';

  meta = with lib; {
    description = "N1URO's Native Linux Packet Node";
    homepage = "https://github.com/sarcasticadmin/uronode";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
}
