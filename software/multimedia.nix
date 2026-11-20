{ pkgs, role, ... }:

{
  home.packages = with pkgs; [
    (vivaldi.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    })
    telegram-desktop

    xwayland-satellite
  ] ++ lib.optionals (role == "home") [ 
    spotify
    kdePackages.kdenlive
    vlc
    tor-browser
    discord
    steam
    mangohud
 ] ++ lib.optionals (role == "work") [ 
    mattermost-desktop
 ];
}
