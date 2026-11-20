# Shared helpers for the Home Manager flake.

# Machine branches (`configuration/*`) build on master's `home.nix` and only add
# (identity + extra modules). This file exposes `mkHM` so every branch does not
# duplicate the module wiring; master passes only the *portable* default.

{ nixpkgs, home-manager }:

let
  system = "x86_64-linux";
in
{
  inherit system;
  pkgs = nixpkgs.legacyPackages.${system};

  # Build a Home Manager configuration for an identity.
  #   username      -> OS user (also used for $HOME default)
  #   host          -> machine label (used only for documentation)
  #   isDebian      -> enable `targets.genericLinux` (standalone HM on non-NixOS)
  #   extraModules  -> machine/role overlays, applied on top of master
  #   extraOverlays -> nixpkgs overlays applied before building the HM pkgs
  #                    (e.g. to add non-upstream packages like `kilocode-cli`)
  mkHM =
    { username
    , host
    , isDebian ? false
    , extraModules ? [ ]
    , extraOverlays ? [ ]
    }:
    let
      basePkgs = nixpkgs.legacyPackages.${system};
      pkgs = basePkgs.extend (nixpkgs.lib.composeManyExtensions extraOverlays);
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit isDebian; };
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