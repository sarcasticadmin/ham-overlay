{ lib
, stdenv
, fetchzip
, alsa-lib
}:
let
  src = fetchzip {
    url = "https://www.cantab.net/users/john.wiseman/Downloads/Beta/ARDOPProjects.zip";
    sha256 = "sha256-YHVsTO0f1VlJSG32RvkPDQx9jVouLFDl5/r+WR/xlLE=";
  };
in
stdenv.mkDerivation rec {
  inherit src;

  pname = "ardopc";

  version = "unstable-2023-01-13";

  sourceRoot = "${src.name}/ARDOPC";

  buildInputs = [ alsa-lib ];

  installPhase = ''
    mkdir -p $out/bin
    install -D -m 755 ardopc $out/bin/ardopc
  '';

  meta = with lib; {
    description = "Amateur Radio Digital Open Protocol";
    homepage = "http://www.cantab.net/users/john.wiseman/Downloads/Beta/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
}
