{ pkgs, ... }:

{
  home.packages = with pkgs; [
    networkmanagerapplet
    pavucontrol
    docker
    wofi-power-menu
    brightnessctl
    (python3.withPackages (
      ps: with ps; [
        requests
        debugpy
      ]
    ))
    blueman
  ];
}
