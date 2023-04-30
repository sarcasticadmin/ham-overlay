{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libxml2
, ncurses5
, pkg-config
, libax25
, python3
}:

stdenv.mkDerivation rec {
  pname = "rmsgw";
  version = "unstable-2021-07-10";

  src = fetchFromGitHub {
    owner = "nwdigitalradio";
    repo = "rmsgw";
    rev = "bd7ec07e0ff76c25402cdb85a29f3acf18f91dbd";
    sha256 = "sha256-zFARMd+JH4Hb690eCt4B5CLiloPNz/pjzjgFTykrwXs=";
  };

  buildInputs = [ autoreconfHook ncurses5 pkg-config libxml2 ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
  ] ++ [ libax25 ];

  configurePhase = ''
    ./configure --prefix=$out
  '';

  # Currently have to move things around since /etc/rmsgw is pretty messy
  # TODO: Still need to confirm all of this works via a live RMS winlink deployment
  postInstall = ''
    rm $out/etc/rmsgw/*help
    rm $out/etc/rmsgw/admin-update.sh

    mv $out/etc/rmsgw/rmsgwchantest $out/bin/
    mv $out/etc/rmsgw/*.py $out/bin/
    mv $out/etc/rmsgw/*.sh $out/bin/

    mkdir $out/share/config
    mv $out/etc/rmsgw/gateway.conf $out/share/config/
    mv $out/etc/rmsgw/banner $out/share/config/
    mv $out/etc/rmsgw/hosts $out/share/config/
    mv $out/etc/rmsgw/*.xml $out/share/config/
    mv $out/etc/rmsgw/channels.xsd $out/share/config/
  '';

  meta = with lib; {
    description = "Winlink RMS Gateway";
    homepage = "https://github.com/nwdigitalradio/rmsgw";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
}
