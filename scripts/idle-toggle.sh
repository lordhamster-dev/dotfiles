#!/bin/bash

# Toggle swayidle (auto-lock / display power-off) on and off.
# Useful during live recordings, presentations, or watching long videos
# when you don't want the screen to lock or displays to turn off.

WALLPAPER="$HOME/dotfiles/wallpapers/fulilian.jpg"
LOCK="swaylock -f -i $WALLPAPER --ring-color cba6f7 --inside-color 1e1e2e --text-color cdd6f4 --key-hl-color cba6f7 --line-color 00000000 --ring-ver-color cba6f7 --inside-ver-color 1e1e2e --ring-wrong-color f38ba8 --inside-wrong-color 1e1e2e"

swayidle_running() {
    pgrep -x swayidle >/dev/null
}

refresh_waybar() {
    # Notify the waybar custom/idle module (signal 9) to re-run its exec
    kill -RTMIN+9 $(pidof waybar) 2>/dev/null
}

start_idle() {
    if swayidle_running; then
        notify-send "🌙 空闲锁定已启用" "swayidle 已在运行"
        return
    fi
    swayidle -w \
        timeout 300 "$LOCK" \
        timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
        before-sleep "$LOCK" &
    sleep 0.2
    notify-send "🌙 空闲锁定已启用" "5 分钟无操作后锁屏"
    refresh_waybar
}

stop_idle() {
    if ! swayidle_running; then
        notify-send "🟢 空闲锁定已禁用" "swayidle 未在运行"
        return
    fi
    pkill -x swayidle
    notify-send "🟢 空闲锁定已禁用" "录播期间不会锁屏/熄屏"
    refresh_waybar
}

toggle_idle() {
    if swayidle_running; then
        stop_idle
    else
        start_idle
    fi
}

case "$1" in
    start) start_idle ;;
    stop) stop_idle ;;
    toggle) toggle_idle ;;
    status) swayidle_running && echo "idle-on" || echo "idle-off" ;;
    *) toggle_idle ;;
esac
