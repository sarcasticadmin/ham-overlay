{ lib
, python3
, fetchFromGitHub
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "flashtnc-unstable";
  version = "2023-05-08";

  src = fetchFromGitHub {
    owner = "ninocarrillo";
    rev = "a41861199d6f887eb58d8cbe492eeeeac74aabb4";
    repo = "flashtnc";
    sha256 = "sha256-s/ljNc4Nsf54DfGIs1jIqdLbjmFekQZ8EJrbZJ5Bg4s=";
  };

  buildInputs = [
    (python3.withPackages
      (pythonPackages: with pythonPackages; [ pyserial ]))
  ];

  # Add shebang so that we can substitute it with the correct path
  patches = [ ./add-shebang.patch ];

  postPatch = ''
    substituteInPlace flashtnc.py \
     --replace '<hex file>' \
               '${placeholder "out"}/firmware/<hex file>'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp flashtnc.py $out/bin/flashtnc
    chmod +x $out/bin/flashtnc
    install -Dt $out/firmware *.hex
  '';

  meta = with lib; {
    description = "Firmware updater for N9600A NinoTNCs";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sarcasticadmin ];
  };
}
