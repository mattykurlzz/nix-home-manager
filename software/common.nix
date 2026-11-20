{ pkgs, ... }:

{
    home.packages = with pkgs; [
      alacritty
      git
      docker
      git-graph
    ];
}
