# This branch: `configuration/home`

Personal profile for **imamontov@NB-9558** (Debian sid), built on top of **master**.

- `flake.nix` exposes `homeConfigurations."imamontov@NB-9558"` via `mkHM` with `isDebian = true`.
- `machines/imamontov.nix` **adds only** the personal/dev profile on master (dev build tools,
  nautilus, flameshot, gnome-keyring). Nothing here removes a master feature.
- The `configuration/work` branch adds work apps on top of this branch.

Apply:
```bash
git checkout configuration/home
git submodule update --init --recursive
home-manager switch --flake '~/.config/home-manager?submodules=1#imamontov@NB-9558' -b backup
```

---

# What this project is for

A portable **standalone Home Manager** setup that can be reused across operating systems
(Debian, NixOS, …) as long as you are willing to tinker with Nix. This is the **master**
branch — the OS-agnostic **default** that all per-machine branches build on.

## Repository / branch model

- **`master`** — the portable *default* config. Content here is **common/essential only**.
  Machine identity (`home.username`, `homeDirectory`, host, `isDebian`) is intentionally **not**
  hardcoded; it is parameterized through `lib.nix` → `mkHM`.
- **`configuration/*`** — per-machine / per-role overlays (e.g. `configuration/home`,
  `configuration/work`). They **branch off `master` (or a sibling configuration branch) and
  ADD ONLY** — they never remove or replace a `master` entry. Unwanted master features are
  disabled via a flag/override *in the branch*, never by deleting from master.
- **`machines/<user>.nix`** — a host's personal/profile overlay.
- **`workers/<role>.nix`** — role overlay (e.g. work) on top of a machine profile.
- **`lib.nix`** — `mkHM` helper so every branch wires modules the same way.

### Creating a new machine branch

```bash
git checkout master
git checkout -b configuration/<myname>
# flake.nix: add yours
homeConfigurations."<user>@<host>" = mkHM {
  username = "<user>";
  host = "<host>";
  isDebian = true;           # false on NixOS
  extraModules = [ ./machines/<user>.nix ];
};
```
Put profile additions in `machines/<user>.nix` (only additions!). Commit, push branch.

## Apply / switch

Always apply with submodules fetched (the `dotfiles` submodule is required):

```bash
home-manager switch --flake '~/.config/home-manager?submodules=1#<user>@<host>' -b backup
```

Update to the latest generation:
```bash
home-manager switch --flake '.?submodules=1#<user>' -b backup
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
# checkout the machine branch, then switch with submodules:
git -C ~/.config/home-manager checkout configuration/home
git -C ~/.config/home-manager submodule init && git -C ~/.config/home-manager submodule update --init --recursive
home-manager switch --flake '~/.config/home-manager?submodules=1#imamontov@NB-9558' -b backup
```
On Debian the flake must pass `isDebian = true` so `targets.genericLinux.enable = true;`
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
nix run home-manager/master -- switch --flake ~/.config/home-manager#<user>@<nixos-host>
```
Note: on NixOS you bootstrap imperatively so HM stays self-sustaining and not tied to the
system config. Use `isDebian = false`.

## Updating
```bash
home-manager switch --flake '.?submodules=1#<user>' -b backup
```