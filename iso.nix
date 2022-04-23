{ modulesPath, lib, ... }:
let
  ham-overlay = import ./default.nix;
  nixpkgs = import <nixpkgs> { overlays = [ ham-overlay ]; };
in
with nixpkgs;
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  environment = {
    # Installs all necessary packages for the iso
    systemPackages = [
      aprx
      tncattach
      libax25
      pat
      flashtnc
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

  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
}
