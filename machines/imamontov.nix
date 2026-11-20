# Personal profile for imamontov@NB-9558 on top of master.
#
# Convention: this module ONLY ADDS to master; it never removes or replaces
# master entries. If a master entry is unwanted here, disable it via a flag/
# override here rather than deleting from master.

{ pkgs, ... }:

{
  # Dev toolchain (was apt): per Step 1 decisions, the host build/dev toolset
  # moves here so it is reproducible and does not pollute the OS.
  home.packages = with pkgs; [
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
    # kilo programming CLI (was npm-global @kilocode/cli)
    kilocode-cli
  ];

  # Secrets for git/bluez/etc. (gnome-keyring was in apt; HM manages the user daemon).
  services.gnome-keyring.enable = true;
}