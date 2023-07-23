{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.services.ax25d;

  ax25ToolsPkg = config.services.ax25d.package;

  kissScript = pkgs.writeScript "kissScript" ''
    #!${pkgs.runtimeShell}
    ${ax25ToolsPkg}/bin/kissattach /dev/ninotnc wl2k
    ${ax25ToolsPkg}/bin/kissparms -p wl2k -t 300 -l 10 -s 12 -r 80 -f n
  '';
in
{

  options = {
    services.ax25d = {
      enable = mkEnableOption (lib.mdDoc "ax25 daemon");

      package = mkOption {
        type = types.package;
        default = pkgs.ax25-tools;
        defaultText = literalExpression "pkgs.ax25-tools";
        description = lib.mdDoc "The ax25-tools package to use.";
      };
    };
  };

  config = {
    systemd.targets.ax25 = {
      description = "AX.25 group target";
      after = [ "network.target" "dev-ninotnc.device" ];
      bindsTo = [ "dev-ninotnc.device" ];
    };
    systemd.services.ax25d = {
      description = "AX.25 KISS interface";
      before = [ "ax25.target" ];
      wantedBy = [ "ax25.target" ];
      bindsTo = [ "ax25.target" ];
      serviceConfig.Type = "oneshot";
      serviceConfig.ExecStart = "${kissScript}";
    };
  };
}
