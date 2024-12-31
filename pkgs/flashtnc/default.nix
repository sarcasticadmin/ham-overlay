{ lib
, python3
, fetchFromGitHub
, stdenv
}:
stdenv.mkDerivation {
  pname = "flashtnc-unstable";
  version = "2024-04-26";

  src = fetchFromGitHub {
    owner = "ninocarrillo";
    rev = "c098c87d5c77ade8e12d51fa1b1720d3cc63c5dd";
    repo = "flashtnc";
    hash = "sha256-Krd7HD6S/b0Xk8DTdpm5xUpb7vhU3hEaPSKIrkCaotw=";
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
