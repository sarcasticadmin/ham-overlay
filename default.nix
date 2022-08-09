self: super:
{
  aprx = super.callPackage ./pkgs/aprx { };
  tncattach = super.callPackage ./pkgs/tncattach { };
  libax25 = super.callPackage ./pkgs/libax25 { };
  ax25-tools = super.callPackage ./pkgs/ax25-tools { };
  ax25-apps = super.callPackage ./pkgs/ax25-apps { };
  pat = super.callPackage ./pkgs/pat { };
  flashtnc = super.callPackage ./pkgs/flashtnc { };
  maidenhead = super.callPackage ./pkgs/maidenhead { };
  hamlib = super.callPackage ./pkgs/hamlib { };
  chirpc = super.callPackage ./pkgs/chirpc { };
}
