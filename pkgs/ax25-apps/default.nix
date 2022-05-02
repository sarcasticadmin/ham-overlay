{ lib, stdenv, libax25, ncurses }:

stdenv.mkDerivation rec {
  pname = "ax25-apps";
  version = "0.0.8-rc5";

  buildInputs = [ libax25 ncurses ];

  # Sources for ax25 can be found here: https://www.linux-ax25.org/pub/
  src = fetchTarball {
    url = "http://www.linux-ax25.org/pub/ax25-apps/ax25-apps-0.0.8-rc5.tar.gz";
    sha256 = "sha256:14gm3zg5nj2jkgm0cjkqkznasq4svg0wxms6gk059lrjbmg4m46h";
  };

  # Ignore prefixing to /nix/store
  # TODO: Make prefix configurable
  configureFlags = [ "--sysconfdir=/etc" ];

  meta = with lib; {
    description = "programs for the hamradio protocol AX.25 that would be used by normal users";
    homepage = "https://www.linux-ax25.org/wiki/ax25-apps";
    license = licenses.lgpl21Only;
    maintainers =  with maintainers; [ sarcasticadmin ];
    platforms = platforms.unix;
  };
}
