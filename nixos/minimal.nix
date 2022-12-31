{ config, pkgs, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];
  boot.kernelPatches = [{
    name = "packet-radio-protocols";
    patch = null;
    extraConfig = ''
      HAMRADIO y
      AX25 y
      AX25_DAMA_SLAVE y
      NETROM m
      ROSE m
      MKISS y
      6PACK y
      BPQETHER y
      BAYCOM_SER_FDX y
      BAYCOM_SER_HDX y
      BAYCOM_PAR m
      YAM y
    '';
  }];

  environment = {
    # Installs all necessary packages for the minimal
    systemPackages = [
      aprx
      ax25-tools
      ax25-apps
      tncattach
      libax25
      pat
      flashtnc
      tmux
      screen
      tio
      kermit
    ];

    # libax25, etc. are set to assume the common config path
    # TODO: Definitely need to come up with a beter way to deal with this
    etc."ax25/axports" = {
      text = ''
        # me callsign speed paclen window description
        #
        wl2k km6lbu-6 57600 255 7 Winlink
      '';

      # The UNIX file mode bits
      mode = "0644";
    };

  };
}
