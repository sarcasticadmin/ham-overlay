{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.services.ax25d;

  ax25ToolsPkg = config.services.ax25d.package;

  axports = t: pkgs.writeText ''
    # me callsign speed paclen window description
    #
    ${t.portName} ${t.callsign} ${t.paclen} ${t.window} nixmanaged
  '';

  kissScript = t: pkgs.writeScript "kissScript" ''
    #! ${pkgs.runtimeShell}
    ${pkgs.ax25-tools}/bin/kissattach /dev/${t.name} ${t.portName}
    ${pkgs.ax25-tools}/bin/kissparms -p ${t.portName} -t 300 -l 10 -s 12 -r 80 -f n
  '';
in
{
  imports = [
    ./hardware/tnc.nix
  ];

  options = {

    services.ax25d = {

      enable = mkEnableOption (lib.mdDoc "ax25 daemon");

      package = mkOption {
        type = types.package;
        default = pkgs.ax25-tools;
        defaultText = literalExpression "pkgs.ax25-tools";
        description = lib.mdDoc "The ax25-tools package to use.";
      };

      #tnc = mkOption {
      #  type = types.attrs;
      #  description = lib.mdDoc "TNC for /etc/axports.";
      #};

      axports = mkOption {
        type = types.nullOr types.path;
        default = null;
        defaultText = literalExpression "axports";
        description = lib.mdDoc ''
          Overridable config file to use for /etc/axports. By default, use
          nixos generated config.
        '';
      };
    };
  };

  config = {

    environment.etc."ax25/axports" = {
      #source = optionalString (cfg.axports == null) (axports config.hardware.tnc);
      source = toString (axports config.hardware.tnc);
      mode = "0644";
    };

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
      serviceConfig.ExecStart = "${kissScript config.hardware.tnc}";
    };
  };
}
