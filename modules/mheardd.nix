{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.services.mheardd;
  ax25ToolsPkg = config.services.mheardd.package;
in
{
  options = {

    services.mheardd = {

      enable = mkEnableOption (lib.mdDoc "mheard server");

      package = mkOption {
        type = types.package;
        default = pkgs.ax25-tools;
        defaultText = literalExpression "pkgs.ax25-tools";
        description = lib.mdDoc "The ax25-tools package to use.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.ax25d.enable = true;

    systemd.services.mheardd =
      {
        description = "display AX.25 calls recently heard";
        after = [ "ax25d.service" ];
        before = [ "ax25.target" ];
        wantedBy = [ "ax25.target" ];
        bindsTo = [ "ax25.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${ax25ToolsPkg}/bin/mheardd -l";
          StateDirectory = "ax25/mheard";
        };
      };
  };
}
