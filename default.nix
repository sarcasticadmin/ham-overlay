self: super:
{
  aprx = super.callPackage ./pkgs/aprx { };
  tncattach = super.callPackage ./pkgs/tncattach { };
  libax25 = super.callPackage ./pkgs/libax25 { };
  pat = super.callPackage ./pkgs/pat { };
  flashtnc = super.callPackage ./pkgs/flashtnc { };
  maidenhead = super.callPackage ./pkgs/maidenhead { };
}
