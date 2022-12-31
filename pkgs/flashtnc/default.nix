{ lib
, python3
, fetchFromGitHub
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "flashtnc-unstable";
  version = "2022-06-12";

  src = fetchFromGitHub {
    owner = "ninocarrillo";
    rev = "c317b2bd4bee3440666bc7b0c5b78a6c11a198c8";
    repo = "flashtnc";
    sha256 = "sha256-vqZzKJmNUoosdoK+sTbrVi4kjwvU8Drmr7vlTVoXEj0=";
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
