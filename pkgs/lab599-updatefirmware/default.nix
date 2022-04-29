{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation {
  pname = "lab599-updatefirmware";
  version = "1.0.1";

  src = fetchurl {
    url = "https://lab599.com/upload/LAB599-updatefirmware-1.0.1-(linux-x64)";
    sha256 = "sha256-WOktImxT9bsa7/LsrBmv0oQtgyLTpxuqRTxbg63h+vM=";
    name = "lab599-updatefirmware";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    install -D -m 755 lab599-updatefirmware $out/bin/lab599-updatefirmware
  '';

  meta = with lib; {
    description = "Update Firmware binary blob for tx-500";
    maintainers =  with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
}
