{ lib, stdenvNoCC, perl }:

stdenvNoCC.mkDerivation {
  pname = "maidenhead-unstable";
  version = "2022-01-30";

  src = ./.;
  
  propagatedBuildInputs = [ perl ];
  
  installPhase = ''
    mkdir -p $out/bin
    install -D -m 755 maidenhead.pl $out/bin/maidenhead
  '';
  
  meta = with lib; {
    description = "Identify maidenhead/LOC based on lat long";
    license = licenses.bsd2;
    maintainers =  with maintainers; [ sarcasticadmin ];
    platforms = platforms.unix;
  };
}
