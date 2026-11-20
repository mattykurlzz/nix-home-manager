{ config, pkgs, role, ... }:

{
  imports = [
    ./artcraft/artcraft.nix
    ./common.nix
    ./code-editors/code-editors.nix
    #     ./ask-sh.nix
    ./multimedia.nix
    ./rclone.nix
    ./yazi.nix
    ./window-manager/window-manager.nix
  ];
}
