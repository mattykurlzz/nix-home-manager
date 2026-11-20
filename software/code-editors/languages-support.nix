{ pkgs, role, ... }:

{
  home.packages = with pkgs; [
    # compilers
    clang # C/C++
    
    # debuggers
    lldb # C/C++

    # lsp
    clang-tools # C/C++, provides clangd
    yaml-language-server # YAML
    lua-language-server # LUA
    biome # JS, TS, JSON
    nil # NIX
    dockerfile-language-server # DOCKER
    docker-compose-language-service # DOCKER COMPOSE

    #formatters
    nixfmt-rs # NIX
    dockerfmt # DOCKER

    # linters
    rust-analyzer # RUST
    pyright # PYTHON
    statix # NIX static linter
    deadnix # NIX dead code analyzer
    hadolint # DOCKERFILE

    # misc
    vscode-extensions.vadimcn.vscode-lldb.adapter
  ]
    ++ lib.optionals (role == "home") [ rustup ];
}
