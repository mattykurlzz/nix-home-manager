# What this project is for 

This project describes my standalone home-manager setup that could be reused across different OS as long as you are willing to tinker with NIX

# Standalone Home Manager Setup (Flakes)

## 1. Debian

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

### Clone & Bootstrap Home Manager
```bash
git clone git@github.com:mattykurlzz/nix-home-manager.git ~/.config/home-manager
nix run home-manager/master -- switch --flake ~/.config/home-manager#<user>@<debian-host>
```
*(Ensure Debian configuration sets `targets.genericLinux.enable = true;`.)*

## 2. NixOS

### Enable Flakes in System Config
Add to `/etc/nixos/configuration.nix` and run `sudo nixos-rebuild switch`:
```nix
{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = [ pkgs.git ];
}
```

### Clone & Bootstrap Home Manager
Run as your regular user:
```bash
git clone git@github.com:mattykurlzz/nix-home-manager.git ~/.config/home-manager
nix run home-manager/master -- switch --flake ~/.config/home-manager#<user>@<nixos-host>
```

Unfortunately, this one you will have to do imperatively because you want to have self-sustaining HM that is not tied to your current system config.

## Updating 
After HM setup, updating is the same for any OS:
```bash
home-manager switch --flake ~/.config/home-manager#<user>@<host>
```
