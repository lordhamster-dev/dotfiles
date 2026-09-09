#!/bin/sh

WALLPAPER="$HOME/dotfiles/wallpapers/fulilian.jpg"

lock_screen() {
    swaylock -f \
        -i "$WALLPAPER" \
        --ring-color cba6f7 \
        --inside-color 1e1e2e \
        --text-color cdd6f4 \
        --key-hl-color cba6f7 \
        --line-color 00000000 \
        --ring-ver-color cba6f7 \
        --inside-ver-color 1e1e2e \
        --ring-wrong-color f38ba8 \
        --inside-wrong-color 1e1e2e
}

CHOSEN=$(printf '%s\n' " Lock" "󰤄 Suspend" "󰜉 Reboot" "󰐥 Shutdown" | fuzzel -d --width 30 --lines=4)

case "$CHOSEN" in
    " Lock") lock_screen ;;
    "󰤄 Suspend") systemctl suspend ;;
    "󰜉 Reboot") systemctl reboot ;;
    "󰐥 Shutdown") systemctl poweroff ;;
    *) exit 1 ;;
esac
