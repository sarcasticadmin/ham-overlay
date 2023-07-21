{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.tnc;
  inherit (lib) mdDoc mkIf mkOption types;

  udevRulesTNC = pkgs.writeTextFile {
    name = "tnc-udev-rules";
    text = ''
      KERNEL=="${cfg.device}", SUBSYSTEMS=="usb", ATTRS{idProduct}=="00dd", SYMLINK+="${cfg.name}" TAG+="systemd" ENV{SYSTEMD_WANTS}+="ax25.target"
    '';
    destination = "/etc/udev/rules.d/99-tnc.rules";
  };

in
{
  options = {

    hardware.tnc = {

      callsign = mkOption {
        type = types.str;
        default = "nocall";
        description = lib.mdDoc "Callsign for /etc/axports. Must be
        set to valid callsign before transmitting.";
      };

      device = mkOption {
        type = types.str;
        default = "ttyACM*";
        description = lib.mdDoc "Default packet device name in /dev path.";
      };

      name = mkOption {
        type = types.str;
        default = "tnc";
        description = lib.mdDoc "Symlink name for /dev path.";
      };

      portName = mkOption {
        type = types.str;
        default = "wl2k";
        description = lib.mdDoc "The unique identifier of the port.
        This is the name given as the port argument of many of the
        AX.25 support programs.";
      };

      speed = mkOption {
        type = types.int;
        default = 57600;
        description = lib.mdDoc "This is the speed of interface.";
      };

      paclen = mkOption {
        type = types.int;
        default = 255;
        description = lib.mdDoc "The default maximum packet size for this interface.";
      };

      window = mkOption {
        type = types.int;
        default = 7;
        description = lib.mdDoc "The default window size for this interface.";
      };

    };

    config = {
      services.udev.packages = [ udevRulesTNC ];
    };
  };
}
