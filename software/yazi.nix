{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;

    plugins.gvfs = {
      package = pkgs.yaziPlugins.gvfs;
      setup = true;
    };
  };
}
