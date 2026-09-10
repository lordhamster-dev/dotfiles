#!/bin/sh

lock_screen() {
    "$HOME/dotfiles/scripts/lock-screen.sh"
}

CHOSEN=$(printf '%s\n' " Lock" "󰤄 Suspend" "󰜉 Reboot" "󰐥 Shutdown" | fuzzel -d --width 30 --lines=5)

case "$CHOSEN" in
    " Lock") lock_screen ;;
    "󰤄 Suspend") systemctl suspend ;;
    "󰜉 Reboot") systemctl reboot ;;
    "󰐥 Shutdown") systemctl poweroff ;;
    *) exit 1 ;;
esac
