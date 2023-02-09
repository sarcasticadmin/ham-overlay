{
  inputs = {
    # many pkgs upstream havent made it in an official release yet
    nixpkgs.url = "nixpkgs/master";
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
      overlays.default = import ./default.nix;

      nixosConfigurations = {
        minimal = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ modulesPath, ... }: {
              imports = [
                "${toString modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
              ];
            })
            ./nixos/minimal.nix
          ];
        };
        minimalrun = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = "x86_64-linux";
          modules = [
            ./nixos/minimal.nix
          ];
        };
      };

      # Like nix-shell
      # Good example: https://github.com/tcdi/pgx/blob/master/flake.nix
      #devShells = forAllSystems (system:
      #  let
      #    pkgs = nixpkgsFor.${system};
      #  in
      #  {
      #    default = import ./shell.nix { inherit pkgs; };
      #  });
    };
  # Bold green prompt for `nix develop`
  # Had to add extra escape chars to each special char
  nixConfig.bash-prompt = "\\[\\033[01;32m\\][nix-flakes \\W] \$\\[\\033[00m\\] ";
}
