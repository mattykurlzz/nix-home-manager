# Work profile additions (imamontov@NB-9558, Debian). In the merged single-branch
# model this module is only imported when `role == "work"` (see lib.nix mkConfig).
# ADDS ONLY, never removes base entries.
#
# Note: work security/EDR (kesl, klnagent64, wazuh-agent), CryptoPro (cprocsp-*) and
# proxy clients (hiddify, sing-box, v2ray, v2rayn, proxychains4) stay as system apt
# services per Step 1 decisions — they are NOT managed by Home Manager.

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mattermost-desktop
    rustdesk
    weylus
    obs-studio
  ];
}