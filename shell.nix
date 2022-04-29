let
  ham-overlay = import ./default.nix;
  nixpkgs = import <nixpkgs> { overlays = [ ham-overlay ]; };
in
with nixpkgs;
mkShell {
  buildInputs = [
    aprx
    tncattach
    libax25
    ax25-tools
    pat
    flashtnc
    lab599-updatefirmware
  ];
}
