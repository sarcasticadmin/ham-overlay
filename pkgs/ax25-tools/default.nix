{ lib, stdenv, libax25 }:

stdenv.mkDerivation rec {
  pname = "ax25-tools";
  version = "0.0.10-rc5";

  buildInputs = [ libax25 ];

  # Sources for ax25 can be found here: https://www.linux-ax25.org/pub/
  src = fetchTarball {
    url = "https://www.linux-ax25.org/pub/ax25-tools/ax25-tools-0.0.10-rc5.tar.gz";
    sha256 = "1kv9b0vzapl69067q0qq8cm840f1cnxf6qdiksm78q5jjpnis5rs";
  };

  meta = with lib; {
    description = "ax25 tools";
    homepage = "https://www.linux-ax25.org/wiki/ax25-tools";
    license = licenses.lgpl21Only;
    maintainers =  with maintainers; [ sarcasticadmin ];
    platforms = platforms.unix;
  };
}
