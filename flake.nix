{
  description = "Home Manager flake — imamontov@NB-9558 (branch: configuration/work = home profile + work additions).";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      lib' = import ./lib.nix { inherit nixpkgs home-manager; };
      mkHM = lib'.mkHM;
      # Overlay adding non-upstream packages (kilo CLI packaged from its npm
      # platform tarball). Keep it portable to master so every branch can use it.
      kiloOverlay = final: prev: {
        kilocode-cli = final.callPackage ./packages/kilo.nix { };
      };
    in
    {
      homeConfigurations."imamontov@NB-9558" = mkHM {
        username = "imamontov";
        host = "NB-9558";
        isDebian = true;
        extraOverlays = [ kiloOverlay ];
        extraModules = [
          ./machines/imamontov.nix
          ./workers/work.nix
        ];
      };
    };
}