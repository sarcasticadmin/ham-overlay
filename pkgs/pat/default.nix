{ lib, buildGoModule, fetchFromGitHub, libax25}:

buildGoModule rec {
  pname = "pat";
  version = "0.11.0";
  owner = "la5nta";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit owner rev;
    repo = pname;
    sha256 = "1cvmikifxqfcwmvf0ry29bdaz916a6znffkhcx50icx7zmcdyjry";
  };

  vendorSha256 = "00dfhb34aabqhy4zyvz5389a502p7jnmwb3zglsdvvmy6hr9rk59";

  # Seems to work out instead of explicitly setting CGO_LDFLAGS & CGO_CFLAGS
  buildInputs = [ libax25 ];

  # tags need to be specified for libax25 regardless of it being in build PATH
  # https://github.com/la5nta/pat/blob/18d49336be03f6873ba377a6ad127a782205b09c/make.bash#L58
  tags = [ "libax25" ];

  # Mimicked dependencies and build procedure
  # https://github.com/la5nta/pat/blob/master/make.bash
  # Need to fix rev to actually be commit hash
  ldflags = [
    "-X main.GitRev=${rev}"
  ];

  meta = with lib; {
    description = "A cross platform Winlink client with basic messaging capabilities";
    homepage = "https://getpat.io/";
    maintainers =  with maintainers; [ sarcasticadmin ];
    license = licenses.mit;
  };
}
