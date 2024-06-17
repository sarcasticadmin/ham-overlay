{ pkgs, ... }:
let
in
  {
      name = "core";
      nodes = {
              # temporary router since we do not have the junipers for ipv6 router advertisement
              router = { ... }: {
                      systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
              };
      };
      testScript = { nodes, ... }:
    ''
      start_all()
      router.wait_for_unit("systemd-networkd-wait-online.service")
    '';

}
