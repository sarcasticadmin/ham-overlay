{
  inputs = {
    # many pkgs upstream havent made it in an official release yet
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
        ];
        config = { allowUnfree = true; };
      };
    in
    {
      overlays.default = (final: prev:
        with final.pkgs;
        rec {
          aprx = callPackage ./pkgs/aprx { };
          ardopc = callPackage ./pkgs/ardopc { };
          pat = callPackage ./pkgs/pat { };
          flashtnc = callPackage ./pkgs/flashtnc { };
          maidenhead = callPackage ./pkgs/maidenhead { };
          rmsgw = callPackage ./pkgs/rmsgw { };
          wwl = callPackage ./pkgs/wwl { };
          uronode = callPackage ./pkgs/uronode { };
        }
      );

      packages.x86_64-linux =
        with pkgs; {
          inherit
            aprx
            ardopc
            pat
            flashtnc
            maidenhead
            rmsgw
            uronode
            wwl;
        };

      nixosModules.default = {
        aprx = import ./modules/aprx.nix;
        ax25d = import ./modules/ax25d.nix;
        axlistend = import ./modules/axlistend.nix;
        beacond = import ./modules/beacond.nix;
        mheardd = import ./modules/mheardd.nix;
      };

    };

  # Bold green prompt for `nix develop`
  # Had to add extra escape chars to each special char
  nixConfig.bash-prompt = "\\[\\033[01;32m\\][nix-flakes \\W] \$\\[\\033[00m\\] ";
}
