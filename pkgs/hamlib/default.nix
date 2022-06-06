{ lib, stdenv, fetchgit, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "hamlib-unstable";
  version = "2022-04-28";

  src = fetchgit {
    url = "https://github.com/Hamlib/Hamlib";
    rev = "4b64d5f7c37882c6bddcaad82be8c7b3dd0aace4";
    sha256 = "sha256-z8h9pYiNSAj6wmGyGABI88+NTCzDA4u/a0PimlP90rY=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Ham radio control library for rigs, rotators, tuners, and amplifiers";
    homepage = "https://github.com/Hamlib/Hamlib";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
}
