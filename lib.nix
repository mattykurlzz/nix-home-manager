# Shared helpers for the Home Manager flake.
#
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
  mkConfig =
    { username
    , host
    , role ? "base"
    , isDebian ? false
#     , personal ? false
    , extraModules ? [ ]
    }:
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
        ++ extraModules;
    };
}
