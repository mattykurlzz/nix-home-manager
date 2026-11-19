{ pkgs, config, lib, isDebian ? false, ... }:

{
  imports = [
    ./software/software.nix
  ];

  # Machine identity (username / home dir / host) is intentionally NOT set here:
  # master is the portable default. The `configuration/*` branches (via `lib.mkHM`)
  # supply the real identity and os-specific flags.
  #
  # Standalone Home Manager on bare Debian / generic Linux needs this so the profile's
  # `bin` dirs are added to PATH and activation approximates NixOS. It must stay OFF
  # on NixOS (which provides its own activation).
  targets.genericLinux.enable = isDebian;

  home.stateVersion = "26.05"; # do not change

  # Expose blesh at the path your script already uses
  home.file.".local/share/blesh".source = "${pkgs.blesh}/share/blesh";
  home.file.".blerc".source = ./dotfiles/.blerc;
  home.file.".config" = {
    source = ./dotfiles/.config;
    recursive = true;
  };

  programs.bash = {
    enable = true;
    historyControl = [ "ignoreboth" ];
    historySize = 1000;
    historyFileSize = 2000;
    shellOptions = [
      "histappend"
      "checkwinsize"
    ];
    enableCompletion = true;

    initExtra = builtins.readFile ./dotfiles/.bashrc;
  };
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}