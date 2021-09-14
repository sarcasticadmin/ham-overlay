self: super:
{
  aprx = super.callPackage ./pkgs/aprx { };
  tncattach = super.callPackage ./pkgs/tncattach { };
  libax25 = super.callPackage ./pkgs/libax25 { };
}
