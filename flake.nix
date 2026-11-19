{
  description = "Home Manager flake — imamontov@NB-9558 (branch: configuration/home, personal profile on master).";

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
      # Apply with:
      #   home-manager switch --flake '~/.config/home-manager#imamontov@NB-9558'
      homeConfigurations."imamontov@NB-9558" = mkHM {
        username = "imamontov";
        host = "NB-9558";
        isDebian = true;
        extraModules = [ ./machines/imamontov.nix ];
      };
    };
}