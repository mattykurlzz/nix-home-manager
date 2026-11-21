{
  pkgs,
  config,
  lib,
  isDebian,
  role,
  ...
}:

{
  imports = [
    ./software/software.nix
  ];

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

  services.gnome-keyring.enable = true;
}
