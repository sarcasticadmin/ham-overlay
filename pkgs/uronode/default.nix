{ lib
, stdenv
, fetchFromGithub
, libax25
}:
stdenv.mkDerivation rec {

  pname = "uronode";

  version = "2.15";

  src = fetchFromGithub {
    owner = "sarcasticadmin";
    repo = "uronode";
    rev = "${version}";
    sha256 = "";
  };

  buildInputs = [ libax25 ];

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
