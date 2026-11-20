{ pkgs, lib, role ? "base", ... }:

{
    home.packages = with pkgs; [
      alacritty
      git
      docker
      git-graph
    ] ++ lib.optionals (role == "work") [ pass ];
}
