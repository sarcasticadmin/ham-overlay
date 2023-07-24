{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.services.axlistend;
  ax25AppsPkg = config.services.axlistend.package;
in
{
  options = {

    services.axlistend = {

      enable = mkEnableOption (lib.mdDoc "axlisten server");

      package = mkOption {
        type = types.package;
        default = pkgs.ax25-apps;
        defaultText = literalExpression "pkgs.ax25-apps";
        description = lib.mdDoc "The ax25-apps package to use.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.ax25d.enable = true;

    systemd.services.axlistend =
      {
        description = "monitor AX.25 traffic";
        after = [ "ax25d.service" ];
        before = [ "ax25.target" ];
        wantedBy = [ "ax25.target" ];
        bindsTo = [ "ax25.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${ax25AppsPkg}/bin/axlisten -artttt";
        };
      };
  };
}
