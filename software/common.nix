{
  pkgs,
  lib,
  role,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      alacritty
      git
      docker
      docker-compose
      git-graph

      # For yazi gvfs mount
      glib
    ]
    ++ lib.optionals (role == "work") [ pass ];
}
