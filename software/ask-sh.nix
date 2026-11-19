{ config, pkgs, ... }:

let
  ask-sh =
    pkgs.runCommand "ask-sh"
      {
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/TBXark/ask.sh/master/ask.sh";
          sha256 = "sha256-PVT+czVsvGdz8Xumbu02k0pU3QOFjG6U+lCZjWgT5eg=";
        };
      }
      ''
        install -Dm755 "$src" "$out/bin/ask"
        patchShebangs "$out/bin/ask"
      '';
in
{
  home-manager.users."avnek" = {
    home.packages = [
      ask-sh
      pkgs.jq
    ];
  };
}
