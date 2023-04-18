{ lib
, python3
, fetchFromGitHub
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "flashtnc-unstable";
  version = "2023-03-01";

  src = fetchFromGitHub {
    owner = "ninocarrillo";
    rev = "6f17ae1887d770569523909ef39dfb975f2fd71b";
    repo = "flashtnc";
    sha256 = "sha256-9/nwgAcvZ9aLyHHSyEyIoS3fmOlsmHQdTR2edrozWhI=";
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
