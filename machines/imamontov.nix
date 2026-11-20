# Personal/dev profile for imamontov@NB-9558, merged from the former
# configuration/home + configuration/work machine modules and made role-aware.
#
# Convention (merged model): the portable base lives on master; anything that is
# NOT common to every OS/role is written here as an mkIf/optionals on `role` /
# `isDebian`, never as a branch. This module only ADDS; disable via a flag here
# rather than deleting from the base.

{ pkgs, lib, role ? "base", ... }:

{
  # Dev toolchain (was apt): the host build/dev toolset lives here so it is
  # reproducible and does not pollute the OS. Shared by home (NixOS) and work.
  home.packages = with pkgs;
    [
      # build/dev
      cmake
      ninja
      gdb
      bear
      flex
      bison
      doxygen
      graphviz
      # languages (rust toolchain for building)
      cargo
      rustc
      # misc dev/format
      shfmt
      tree
      pandoc
      # GUI/desktop additions kept by decision
      flameshot
      nautilus
      # go toolchain (golang from apt -> HM go)
      go
      # lua package manager (luarocks was apt)
      luarocks
    ]
    # Home (NixOS) additionally tracks Rust via rustup.
    ++ lib.optionals (role == "home") [ rustup ]
    # Work additionally carries the kilo programming CLI (was npm-global).
    ++ lib.optionals (role == "work") [ kilocode-cli ];

  # Secrets for git/bluez/etc. (gnome-keyring was in apt; HM manages the user daemon).
  services.gnome-keyring.enable = true;
}