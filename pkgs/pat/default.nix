{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, libax25
, testers
, pat
}:

buildGoModule rec {
  pname = "pat";
  version = "0.14.1";
  owner = "la5nta";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit owner rev;
    repo = pname;
    sha256 = "sha256-8xOWp7dKHOsl1Xjs20UbJMt8P+gAK2mVjEs9AVS3Gj4=";
  };

  vendorSha256 = "sha256-14s2ijXsOArCZd7sOTbHSP0mfIXGF1J7c9wfzyEnAE8=";

  buildInputs = lib.optional stdenv.isLinux [ libax25 ];

  # Needed by wl2k-go go module for libax25 to include support for Linux' AX.25 stack by linking against libax25.
  # ref: https://github.com/la5nta/wl2k-go/blob/abe3ae5bf6a2eec670a21672d461d1c3e1d4c2f3/transport/ax25/ax25.go#L11-L17
  tags = lib.optionals stdenv.isLinux [ "libax25" ];

  ldflags = [
    "-X github.com/la5nta/pat/internal/buildinfo.GitRev=${src.rev}"
  ];

  postInstall = ''
    install -D -m 644 man/pat-configure.1 $out/share/man/man1/pat-configure.1
    install -D -m 644 man/pat.1 $out/share/man/man1/pat.1
  '';

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = pat;
    command = "pat version";
  };


  meta = with lib; {
    description = "A cross platform Winlink client written in Go";
    homepage = "https://getpat.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.unix;
  };
}
