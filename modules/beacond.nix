{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.services.beacond;
  ax25ToolsPkg = config.services.beacond.package;
in
{
  options = {
    services.beacond = {
      enable = mkEnableOption (lib.mdDoc "beacon server");

      package = mkOption {
        type = types.package;
        default = pkgs.ax25-tools;
        defaultText = literalExpression "pkgs.ax25-tools";
        description = lib.mdDoc "The ax25-tools package to use.";
      };

      message = mkOption {
        type = types.str;
        default = "hello from nixos";
        description = lib.mdDoc "The message to beacon";
      };

      port = mkOption {
        type = types.str;
        default = "wl2k";
        description = lib.mdDoc "ax25 port to beacon on";
      };

      interval = mkOption {
        type = types.int;
        default = "30";
        description = lib.mdDoc "ax25 beacon interval in minutes";
      };
    };
  };

  config = mkIf cfg.enable {
    services.ax25d.enable = true;

    systemd.services.beacond =
      {
        description = "beacon message via AX.25";
        after = [ "ax25d.service" ];
        before = [ "ax25.target" ];
        wantedBy = [ "ax25.target" ];
        bindsTo = [ "ax25.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${ax25ToolsPkg}/bin/beacon -f -l -t ${toString cfg.interval} ${cfg.port} '${cfg.message}'";
        };
      };
  };
}
