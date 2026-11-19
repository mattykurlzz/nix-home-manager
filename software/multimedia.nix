{ pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify
    kdePackages.kdenlive
    vlc

    (vivaldi.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    })
    tor-browser
    telegram-desktop
    discord
    steam
    mangohud

    xwayland-satellite
  ];
}
