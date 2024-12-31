{ lib
, python3
, fetchFromGitHub
, stdenv
}:
stdenv.mkDerivation {
  pname = "flashtnc-unstable";
  version = "2024-11-17";

  src = fetchFromGitHub {
    owner = "ninocarrillo";
    rev = "3ce2db6aaedc3cd5539b0fc21f762c635145e29c";
    repo = "flashtnc";
    hash = "sha256-yI5N/9vqteqvol2mvQY3+EO31TLpy8cL8Uwiupc011I=";
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
