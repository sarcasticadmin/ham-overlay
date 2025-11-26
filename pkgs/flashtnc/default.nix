{ lib
, python3
, fetchFromGitHub
, stdenvNoCC
}:
stdenvNoCC.mkDerivation {
  pname = "flashtnc-unstable";
  version = "2025-10-10";

  src = fetchFromGitHub {
    owner = "ninocarrillo";
    rev = "c9451b52726d2701f836e6b7763ad14dc1f2eef9";
    repo = "flashtnc";
    hash = "sha256-1hMn6HmLYootBjJxiJJd0QWi5Y7aVOZswNN732FrhrY=";
  };

  buildInputs = [
    (python3.withPackages
      (pythonPackages: with pythonPackages; [ pyserial ]))
  ];

  # Add shebang so that we can substitute it with the correct path
  patches = [ ./add-shebang.patch ];

  postPatch = ''
    substituteInPlace flashtnc.py \
     --replace-fail '<hex file>' '${placeholder "out"}/firmware/<hex file>'
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
