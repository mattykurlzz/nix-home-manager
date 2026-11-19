{
  description = "Standalone Home Manager Flake — portable default (master). Per-machine identity and overrides live on the configuration/* branches.";

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
      # Portable default/CI configuration. Real per-machine configs live on the
      # configuration/* branches, e.g.:
      #   home-manager switch --flake '~/.config/home-manager#imamontov@NB-9558'
      homeConfigurations."default" = mkHM {
        username = let u = builtins.getEnv "USER"; in if u == "" then "default" else u;
        host = "default";
      };
    };
}