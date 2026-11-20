# Shared helpers for the Home Manager flake.
#
# Single-branch model (master): one flake, no per-OS branches. Per-OS and
# per-role differences are selected at BUILD time by which config you invoke:
#   - isDebian  -> standalone HM on bare Debian/generic Linux (vs. NixOS)
#   - role      -> which package/use groups get enabled ("base" | "home" | "work")
# This file exposes `mkConfig` so the portable base and all machine configs share
# the same module wiring.

{ nixpkgs, home-manager }:

let
  system = "x86_64-linux";

  # Overlay adding non-upstream packages (e.g. kilo CLI packaged from its npm
  # platform tarball) to every config's package set. Applying the overlay only
  # makes the package AVAILABLE; whether it is installed is decided per-role.
  baseOverlays = final: prev: {
    kilocode-cli = final.callPackage ./packages/kilo.nix { };
  };
in
{
  inherit system baseOverlays;

  # Build a Home Manager configuration for an identity.
  #   username     -> OS user (also used for $HOME default)
  #   host         -> machine label (used only for documentation)
  #   role         -> "base" | "home" | "work"; selects mkIf-gated package groups
  #   isDebian     -> enable `targets.genericLinux` (standalone HM on non-NixOS)
  #   personal     -> include the imamontov@NB-9558 personal/dev profile
  #   extraModules -> additional modules on top of everything bundled here
  mkConfig =
    { username
    , host
    , role ? "base"
    , isDebian ? false
    , personal ? false
    , extraModules ? [ ]
    }:
    let
      roleModules =
        if personal
        then [ ./machines/imamontov.nix ]
        else [ ];
      workModules =
        if role == "work"
        then [ ./workers/work.nix ]
        else [ ];
    in
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system}.extend baseOverlays;
      extraSpecialArgs = { inherit isDebian role; };
      modules =
        [
          ./home.nix
          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
          }
        ]
        ++ roleModules
        ++ workModules
        ++ extraModules;
    };
}