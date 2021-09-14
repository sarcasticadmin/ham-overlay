{ lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "libax25";
  version = "0.0.12-rc5";

  # Sources for ax25 can be found here: https://www.linux-ax25.org/pub/
  src = fetchTarball {
    url = "https://www.linux-ax25.org/pub/ax25-lib/libax25-0.0.12-rc5.tar.gz";
    sha256 = "1xnxab6n8w8b00dmg5idb6xwqs3llqsl0wv6s3xkf72pn1p1f7k5";
  };

  meta = with lib; {
    description = "A set of functions making it easier to write hamradio programs";
    homepage = "https://www.linux-ax25.org/wiki/Libax25";
    license = licenses.lgpl21Only;
    maintainers =  with maintainers; [ sarcasticadmin ];
    platforms = platforms.unix;
  };
}
