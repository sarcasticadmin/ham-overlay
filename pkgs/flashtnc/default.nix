{ lib
, python3
, fetchFromGitHub
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "flashtnc-unstable";
  version = "2022-05-04";

  src = fetchFromGitHub {
    owner = "ninocarrillo";
    rev = "a7c8d820e803c20ca28e9ebf3042c97d1a2ba88e";
    repo = "flashtnc";
    sha256 = "sha256-fYfQbfE9bEcIDuvc00ecxMtR1yuHhNRhFLVZqKMOhQg=";
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
