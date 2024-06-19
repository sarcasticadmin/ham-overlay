{ pkgs, lib, ... }:
let
  createAX25Node = nodeId: {
      imports = [
        ../modules/ax25d.nix
        ../modules/axlistend.nix
        ../modules/mheardd.nix
      ];
      boot.kernelPatches = [{
        name = "ax25-ham";
        patch = null;
        extraStructuredConfig = with lib.kernel; {
          HAMRADIO = lib.kernel.yes;
          AX25 = lib.kernel.module;
        };
      }];
      # TODO
      #DISABLE FIREWALL
      networking.firewall.enable = false;
      boot.kernelModules = [ "ax25" ];
      environment.systemPackages = with pkgs; [
        libax25
        ax25-tools
        ax25-apps
        socat
        tncattach
      ];
      #systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
      environment.etc."ax25/axports" = {
        text = ''
          # me callsign speed paclen window description
          #
          wl2k nocall-${toString nodeId} 57600 255 7 Winlink
        '';

        # The UNIX file mode bits
        mode = "0644";
      };
      services.ax25d = {
        enable = true;
        #kissScript = pkgs.writeScript "kissScript" ''
        #  #!${pkgs.runtimeShell}
        #  ${pkgs.ax25Tools}/bin/kissattach /dev/ham0 wl2k
        #  ${pkgs.ax25Tools}/bin/kissparms -p wl2k -t 300 -l 10 -s 12 -r 80 -f n
        #'';
      };
      services.axlistend = {
    enable = true;
  };
     services.mheardd = {
    enable = true;
  };
    };
in
{
  name = "ax25simple";
  nodes = {
    node1 = createAX25Node 1;
    node2 = createAX25Node 2;
    node3 = createAX25Node 3;
  };
  testScript = { nodes, ... }:
    ''
      start_all()
      node1.succeed("lsmod | grep ax25")
      node1.wait_for_unit("network.target")
      node1.execute("socat-mux.sh tcp4-listen:1234,reuseaddr,fork pty,link=/dev/ninotnc,b57600,raw,echo=0 >&2 &")
      node1.succeed("pgrep socat")
      node1.succeed("systemctl restart ax25d.service")
      node2.wait_for_unit("network.target")
      node2.execute("socat -d -d pty,link=/dev/ninotnc,b57600,raw,echo=0 tcp:192.168.1.1:1234 >&2 &")
      node2.succeed("pgrep socat")
      node2.succeed("systemctl restart ax25d.service")
      node3.wait_for_unit("network.target")
      node3.execute("socat -d -d pty,link=/dev/ninotnc,b57600,raw,echo=0 tcp:192.168.1.1:1234 >&2 &")
      node3.succeed("pgrep socat")
      node3.succeed("systemctl restart ax25d.service")
    '';

}
