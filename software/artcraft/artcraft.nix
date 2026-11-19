{
  config,
  pkgs,
  lib,
  ...
}:

let
  sources = import ../../npins;
  deckcraft = pkgs.callPackage ./deckcraft.nix {
    src = sources.deckcraft;
  };
  # add sources with npins add <...>
in
{
  home.packages = [
    deckcraft
  ];
}
