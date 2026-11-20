{
  description = "Standalone Home Manager flake — portable base + per-OS/per-role configs, all on master (no per-OS branches).";

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
      mkConfig = lib'.mkConfig;
    in
    {
      # Portable default / CI configuration: no OS, no role, no personal profile.
      homeConfigurations."default" = mkConfig {
        username = let u = builtins.getEnv "USER"; in if u == "" then "default" else u;
        host = "default";
        role = "base";
      };

      # Work use on Debian: personal/dev profile + work apps + kilo CLI + niri/waybar.
      homeConfigurations."imamontov" = mkConfig {
        username = "imamontov";
        host = "NB-9558";
        role = "work";
        isDebian = true;
#         personal = true;
      };

      homeConfigurations."avnek" = mkConfig {
        username = "avnek";
        host = "avnek";
        role = "home";
        isDebian = false;
#         personal = true;
      };
    };
}
