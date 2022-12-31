let
  ham-overlay = import ./default.nix;
  nixpkgs = import <nixpkgs> { overlays = [ ham-overlay ]; };
in
with nixpkgs;
mkShell {
  buildInputs = [
    #aprx
    #tncattach
    libax25
    pat
    #ax25-tools
    flashtnc
    (python3.withPackages
      (pythonPackages: with pythonPackages; [ pyserial ]))
    #hamlib
  ];
}
