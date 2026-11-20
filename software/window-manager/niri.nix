# niri as a systemd-managed Wayland session.
#
# SDDM's "Niri" entry (Exec=niri-session) starts niri through the user systemd
# manager: it needs `niri.service` to exist, otherwise it cannot start and you
# end up launching `niri` from a TTY by hand. Launching it by hand skips
# `niri-session`'s environment import, so systemd user services (e.g.
# xdg-desktop-portal) never receive WAYLAND_DISPLAY/XDG_CURRENT_DESKTOP, the GTK
# portal cannot open a display and xdg-desktop-portal.service times out in loops
# — apps block on portal calls and feel like they take forever to load.
#
# This module registers niri as a user service (faithful to the unit the niri
# package ships) and adds a niri-native XDG portal backend.

{ pkgs, ... }:

{
  # niri-native XDG portal backend: screenshots, global shortcuts, screen share.
  home.packages = [ pkgs.xdg-desktop-portal-wlr ];

  # Explicitly tell portals/apps which compositor we run, so xdg-desktop-portal
  # picks the right backend once the session env is imported.
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
  };

  # Provide the graphical-session target that niri binds to.
  systemd.user.targets.graphical-session = {
    Unit = {
      Description = "Graphical session";
      Documentation = [
        "man:systemd.special(7)"
      ];
    };
  };

  # Register the compositor with the user manager (mirrors the shipped unit).
  systemd.user.services.niri = {
    Unit = {
      Description = "A scrollable-tiling Wayland compositor";
      BindsTo = [ "graphical-session.target" ];
      Before = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" "xdg-desktop-autostart.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "notify";
      Slice = "session.slice";
      ExecStart = "${pkgs.niri}/bin/niri --session";
    };
  };
}