self: super:
{
  aprx = super.callPackage ./pkgs/aprx { };
  pat = super.callPackage ./pkgs/pat { };
  flashtnc = super.callPackage ./pkgs/flashtnc { };
  maidenhead = super.callPackage ./pkgs/maidenhead { };
}
