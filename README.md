# What this project is for

A portable **standalone Home Manager** setup that can be reused across operating systems
(Debian, NixOS, …). Everything lives on **master**: there are no per-OS branches. Per-OS
(`isDebian`) and per-use (`role`) differences are selected at **build time** — you invoke
the config matching the machine you are on.

## Model (single flake, no branches)

- **`lib.nix` → `mkConfig`** — one module-wiring helper. It sets the package set (with the
  `baseOverlays`, e.g. `kilocode-cli`), passes `{ role, isDebian }` to every module, and
  bundles the personal + role profiles. OS and role are **parameters**, not branches.
- **`role`** — `"base"` (portable default), `"home"` (NixOS, personal), `"work"` (Debian, work).
- **`isDebian`** — `true` enables `targets.genericLinux` (standalone HM on non-NixOS); must be
  `false` on NixOS.
- **`machines/imamontov.nix`** — personal/dev profile, role-aware (`mkIf role` picks e.g.
  `rustup` for home, `kilocode-cli` for work).
- **`workers/work.nix`** — work role apps, imported only when `role == "work"`.
- **`software/*`** — portable base software, all roles.
- **`dotfiles`** — git submodule with niri/waybar/alacritty configs, linked by `home.nix`.

Everything follows the rule **ADDS ONLY**: unwanted base features are disabled via a flag /
`mkIf`, never by deleting from a branch (there are no branches).

## Exposed configs (`flake.nix` → `homeConfigurations`)

| Config                        | OS     | role   | notes                              |
| ----------------------------- | ------ | ------ | ---------------------------------- |
| `default`                     | any    | base   | portable / CI                      |
| `imamontov@NB-9558-debian`    | Debian | work   | personal + work + kilo + niri      |
| `imamontov@NB-9558-nixos`     | NixOS  | home   | personal (rustup), no genericLinux |

## Apply / switch

Always apply with submodules fetched (the `dotfiles` submodule is required):

```bash
# Debian (work use):
home-manager switch --flake '~/.config/home-manager?submodules=1#imamontov@NB-9558-debian' -b backup

# NixOS (home use):
home-manager switch --flake '~/.config/home-manager?submodules=1#imamontov@NB-9558-nixos' -b backup

# Update from inside the repo:
home-manager switch --flake '.?submodules=1#imamontov@NB-9558-debian' -b backup
```

## 1. Debian (generic Linux)

### Install Nix
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```
Restart your shell, then verify with `nix --version`.

### Enable Flakes
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Clone & Bootstrap
```bash
git clone git@github.com:mattykurlzz/nix-home-manager.git ~/.config/home-manager
git -C ~/.config/home-manager submodule init && git -C ~/.config/home-manager submodule update --init --recursive
home-manager switch --flake '~/.config/home-manager?submodules=1#imamontov@NB-9558-debian' -b backup
```
On Debian the config passes `isDebian = true` so `targets.genericLinux.enable = true;`
(the profile's bin dirs get added to PATH, etc.). On NixOS it must stay `false`.

## 2. NixOS

### Enable Flakes in system config
Add to `/etc/nixos/configuration.nix` and run `sudo nixos-rebuild switch`:
```nix
{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = [ pkgs.git ];
}
```

### Clone & Bootstrap
```bash
git clone git@github.com:mattykurlzz/nix-home-manager.git ~/.config/home-manager
git -C ~/.config/home-manager submodule update --init --recursive
nix run home-manager/master -- switch --flake ~/.config/home-manager#imamontov@NB-9558-nixos -b backup
```
Note: on NixOS you bootstrap imperatively so HM stays self-sustaining and not tied to the
system config. Use `isDebian = false` (already set for the nixos config).

## Adding a new config (no branch)

```bash
# flake.nix: add an entry
homeConfigurations."<user>@<host>-<os>" = mkConfig {
  username = "<user>";
  host = "<host>";
  role = "<base|home|work>";
  isDebian = true;   # false on NixOS
  personal = true;   # include the imamontov@NB-9558 personal profile, if wanted
};
```
Put machine-specific additions in `machines/<user>.nix` (role-aware `mkIf`s), role apps in
`workers/<role>.nix`. Commit, push to master.