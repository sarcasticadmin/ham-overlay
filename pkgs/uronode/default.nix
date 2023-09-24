{ lib
, stdenv
, fetchFromGitHub
, libax25
, which
, newt
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
  
  makeFlags = [
      "BIN_DIR=${placeholder "out"}/bin"
      "SBIN_DIR=${placeholder "out"}/sbin"
      "MAN_DIR=${placeholder "out"}/share/man"
      ];

  #installPhase = ''
  #  mkdir -p $out/bin
  #  install -D -m 755 ardopc $out/bin/ardopc
  #'';

  meta = with lib; {
    description = "Amateur Radio Digital Open Protocol";
    homepage = "http://www.cantab.net/users/john.wiseman/Downloads/Beta/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
}
