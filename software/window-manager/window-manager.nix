{ pkgs, ... }:

{
  imports = [
    ./power-menu.nix
    ./waybar.nix
  ];
  home.packages = with pkgs; [
    niri
    dms
    swaynotificationcenter
    pkgs.kdePackages.polkit-kde-agent-1
    fuzzel
    swaylock
    swayidle
    wdisplays
    waybar
    swaybg
    xwayland-satellite
    udiskie
  ];
}
