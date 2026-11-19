{ pkgs, ... }:

{
  imports = [
    ./software/software.nix
  ];

  home.username = "avnek";
  home.homeDirectory = "/home/avnek";
  home.stateVersion = "26.05"; # do not change

  # Expose blesh at the path your script already uses
  home.file.".local/share/blesh".source = "${pkgs.blesh}/share/blesh";

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

    initExtra = builtins.readFile ./scripts/bash-init.sh;
  };
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
