# Work profile additions on top of configuration/home (imamontov@NB-9558).
# Like all configuration/* modules: ADDS ONLY, never removes master/home entries.
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