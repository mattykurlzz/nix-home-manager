{
  lib,
  src,
  rustPlatform,
  pkg-config,
  alsa-lib,
  makeWrapper,
  libxkbcommon,
  wayland,
  libGL,
  vulkan-loader,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
}:

rustPlatform.buildRustPackage {
  pname = "deckcraft";
  version = "0.11.1";
  doCheck = false;

  inherit src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "craft-media-0.1.0" = "sha256-JfBkl7/RX3Fn1nCn0bpKsvtFhb8CVfOtkHp/ISuXc00=";
      "craft-pdf-0.1.0" = "sha256-d2HCOcxfiR1i8rw0wjW/uf9svHzeCH3bTVPYJYlwrFU=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    libxkbcommon
    wayland
    libGL
    vulkan-loader
    libx11
    libxcursor
    libxrandr
    libxi
  ];

  cargoBuildFlags = [
    "-p"
    "deckcraft"
  ];

  meta = with lib; {
    description = "Presentation and slide designer";
    license = with licenses; [
      asl20
      mit
    ];
    mainProgram = "deckcraft";
  };

  postFixup = ''
    wrapProgram $out/bin/deckcraft \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          alsa-lib
          libxkbcommon
          wayland
          libGL
          vulkan-loader
          libx11
          libxcursor
          libxrandr
          libxi
        ]
      }
  '';
}
