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

  # Installs all necessary packages for the iso
  environment.systemPackages = [
    aprx
    tncattach
    libax25
    pat
    flashtnc
  ];
  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
}
