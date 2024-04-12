{ lib
, python3
, fetchFromGitHub
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "flashtnc-unstable";
  version = "2024-04-09";

  src = fetchFromGitHub {
    owner = "ninocarrillo";
    rev = "c4d14fddf548843b41ae4f7381910cc42121c182";
    repo = "flashtnc";
    hash = "sha256-5zP+ws41K3U3Dh7mkqJk9alJtm7XidcjEnPpMxu/le0=";
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
