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
    in
    {
      homeConfigurations."imamontov@NB-9558" = mkHM {
        username = "imamontov";
        host = "NB-9558";
        isDebian = true;
        extraModules = [
          ./machines/imamontov.nix
          ./workers/work.nix
        ];
      };
    };
}