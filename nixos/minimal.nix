{ config, pkgs, lib, ... }:

{
  #boot.kernelPatches = [{
  #  name = "packet-radio-protocols";
  #  patch = null;
  #  extraConfig = ''
  #    HAMRADIO y
  #    AX25 y
  #    AX25_DAMA_SLAVE y
  #  '';
  #}];
  boot.kernelPatches = lib.singleton {
    name = "ax25-ham";
    patch = null;
    extraStructuredConfig = with lib.kernel; {
      HAMRADIO = yes;
      AX25 = yes;
      AX25_DAMA_SLAVE = yes;
    };
  };

  environment = {
    # Installs all necessary packages for the minimal
    systemPackages = with pkgs; [
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

  # Bug in kernels ~5.4<5.19
  # Resulting in pat to error with: address already in use error after first connection
  boot.kernelPackages = pkgs.linuxPackages_6_0;

  services.tlp.enable = true;
}
