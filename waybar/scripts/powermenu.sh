#!/bin/sh

# Power menu script using tofi

CHOSEN=$(printf " Lock\n󰤄 Suspend\n󰜉 Reboot\n󰐥 Shutdown" | fuzzel -d --width 30 --lines=6)

case "$CHOSEN" in
	" Lock") hyprlock ;;
	"󰤄 Suspend") systemctl suspend ;;
	"󰜉 Reboot") systemctl reboot ;;
	"󰐥 Shutdown") systemctl poweroff ;;
	*) exit 1 ;;
esac
