{ lib
, fetchFromGitHub
, python2
}:

python2.pkgs.buildPythonApplication rec {
  pname = "chirprc";
  version = "20220807";

  src = fetchFromGitHub {
    owner = "sarcasticadmin";
    repo = "chirp";
    #rev = "21924e44d5e7c49bb5bcf0d12e4377194026bba1";
    #sha256 = "sha256-/g+C6gDPuNpvHmkPChB8cjy5/Z+h4fylFGU3szwF918=";
    rev = "63f4e8cb975b771f6e29044e5addc1224794bebc";
    #sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    sha256 = "sha256-HBA0wWLSiKeY+rOXBOJ+wwewQNNIM10BGeeSaJuJ0gQ=";
  };
  #  rev = "3714:d8618b87d8d5"
  #  url = "http://d-rats.com/hg/chirp.hg";
  #  sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #};
  #sourceRoot = "${src}/chirpc";
  pipInstallFlags = ["--install-option=--clionly"];
  #pipInstallFlags = ["--clionly"];
  #buildPhase = ''
  #   ${python2.interpreter} setup.py bdist_wheel --cli
  #'';

  propagatedBuildInputs = with python2.pkgs; [
    pyserial
  ];

  doCheck = false;

  meta = with lib; {
    description = "A free, open-source tool for programming your amateur radio";
    homepage = "https://chirp.danplanet.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
