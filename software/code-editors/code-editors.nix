{ pkgs, ... }:

{
  imports = [ ./languages-support.nix ];

  home.packages = with pkgs; [
    vscode
    neovim

    # neovim plugins dependencies
    xxd
    git
    luaPackages.gitsigns-nvim
    tree-sitter
    curl
    gnumake
    ripgrep
  ];
}
