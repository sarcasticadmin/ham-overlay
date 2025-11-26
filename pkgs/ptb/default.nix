{
  lib,
  buildGoModule,
  fetchgit,
}:

buildGoModule {
  pname = "ptb";
  version = "unstable";

  src = fetchgit {
    url = "https://git.dl1thm.de/harenber/ptb";
    rev = "dfca7ed80c5fb638013a6024887330d60882c6ec";
    hash = "sha256-4RxXgeDxw41ZnmfQJu9SYRRrQlfiMyeRjZPOdbzwggU=";
  };

  vendorHash = "sha256-YKM+SRKqmAotDoZ6u4w0v5MFaiY/SDm4jqcjUvGKn5s=";

  patches = [
    ./0001-go.mod-go.sum.patch
  ];

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "PACTOR TCP Bridge";
    homepage = "https://git.dl1thm.de/harenber/ptb";
    mainProgram = "ptb";
  };
}
