#!/bin/sh

# Power menu script using tofi

CHOSEN=$(printf "Lock\nSuspend\nReboot\nShutdown\nLog Out" | rofi -dmenu)

case "$CHOSEN" in
	" Lock") hyprlock ;;
	"󰤄 Suspend") systemctl suspend ;;
	"󰜉 Reboot") systemctl reboot ;;
	"󰐥 Shutdown") systemctl poweroff ;;
	*) exit 1 ;;
esac
