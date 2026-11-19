{ pkgs, ... }:

let
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    set -eu

    THEME="$HOME/.config/wofi/power-menu.css"

    chosen=$(printf '%s\n' \
      "󰐥   Shutdown" \
      "󰜉   Reboot" \
      "󰒲   Suspend" \
      "󰌾   Lock" \
      "󰍃   Logout" \
      | ${pkgs.wofi}/bin/wofi --dmenu \
          --prompt "Power" \
          --style "$THEME" \
          --width 300 \
          --lines 5) || exit 0

    case "$chosen" in
      *Shutdown) systemctl poweroff ;;
      *Reboot)   systemctl reboot ;;
      *Suspend)  systemctl suspend ;;
      *Lock)     loginctl lock-session ;;
      *Logout)
        if command -v hyprctl >/dev/null 2>&1; then hyprctl dispatch exit
        elif command -v swaymsg >/dev/null 2>&1; then swaymsg exit
        elif [ -n "''${NIRI_SOCKET:-}" ]; then niri msg action quit
        else loginctl terminate-user "$USER"
        fi
        ;;
    esac
  '';
in
{

    home.packages = [
      power-menu
      pkgs.nerd-fonts.jetbrains-mono # needed for the glyphs
    ];
    programs.wofi.enable = true;
    xdg.configFile."wofi/power-menu.css".text = ''
      @define-color base      #303446;
      @define-color text      #c6d0f5;
      @define-color surface0  #414559;
      @define-color surface1  #51576d;
      @define-color blue      #8caaee;
      @define-color lavender  #babbf1;

      window {
          margin: 0px;
          border: 2px solid @blue;
          border-radius: 14px;
          background-color: @base;
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 14px;
      }

      #input {
          margin: 8px;
          padding: 6px 10px;
          border: none;
          border-radius: 8px;
          color: @text;
          background-color: @surface0;
      }

      #outer-box { margin: 4px; background-color: @base; }
      #inner-box { margin: 4px; background-color: @base; }
      #scroll    { margin: 0px; border: none; }

      #entry { padding: 8px 10px; border-radius: 8px; }
      #entry:selected { background-color: @surface1; }

      #text { color: @text; margin: 0px 4px; }
      #text:selected { color: @lavender; }
    '';
}
