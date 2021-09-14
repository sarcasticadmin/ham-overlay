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
  
  buildInputs = [ libax25 ];
  
  # Mimicked dependencies and build procedure
  # https://github.com/la5nta/pat/blob/master/make.bash
  # Need to fix rev to actually be commit hash
  buildFlagsArray = [
    "-ldflags="
    "-X main.GitRev=${rev}"
  ];

  meta = with lib; {
    description = "A cross platform Winlink client with basic messaging capabilities";
    homepage = "https://getpat.io/";
    maintainers =  with maintainers; [ sarcasticadmin ];
    license = licenses.mit;
  };
}
