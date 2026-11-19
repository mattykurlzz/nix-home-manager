{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.obsidian.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/obsidian \
          --run "systemctl --user start rclone-gdrive.service" \
          --add-flags "--no-sandbox" \
          --run "trap 'systemctl --user stop rclone-gdrive.service' EXIT"
      '';
    }))
  ];
}
