{ lib
, fetchhg
, python2
}:

let
  src = ./chirp.hg;

in
python2.pkgs.buildPythonApplication rec {
  inherit src;
  pname = "chirp-daily";
  version = "20220727";

  #src = fetchurl {
  #  rev = "3714:d8618b87d8d5"
  #  url = "http://d-rats.com/hg/chirp.hg";
  #  sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #};
  #sourceRoot = "${src}/chirpc";

  propagatedBuildInputs = with python2.pkgs; [
    pyserial
  ];

  doCheck = false;

  meta = with lib; {
    description = "A free, open-source tool for programming your amateur radio";
    homepage = "https://chirp.danplanet.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
