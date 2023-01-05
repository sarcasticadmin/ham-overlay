{
  inputs = {
    # many pkgs upstream havent made it in an official release yet
    nixpkgs.url = "nixpkgs/master";
  };
  outputs = { self, nixpkgs, ... }:
    let
      # System types to support.
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlays.default ]; });
      #nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ ]; });
    in
    {
      overlays.default = import ./default.nix;

      nixosConfigurations = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          minimal = nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            modules = [
              ({ modulesPath, ... }: {
                imports = [
                  "${toString modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
                ];
              })
              ./nixos/minimal.nix
            ];
          };
        });

      # Like nix-shell
      # Good example: https://github.com/tcdi/pgx/blob/master/flake.nix
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = import ./shell.nix { inherit pkgs; };
        });
    };
  # Bold green prompt for `nix develop`
  # Had to add extra escape chars to each special char
  nixConfig.bash-prompt = "\\[\\033[01;32m\\][nix-flakes \\W] \$\\[\\033[00m\\] ";
}
