#!/bin/sh

set -eu

WALLPAPER_DIR=${WALLPAPER_DIR:-"$HOME/dotfiles/wallpapers"}
STATE_DIR=${XDG_STATE_HOME:-"$HOME/.local/state"}/dotfiles
STATE_FILE="$STATE_DIR/current-wallpaper"
DEFAULT_WALLPAPER="$WALLPAPER_DIR/FrierenMagicalMemory.png"

current_wallpaper() {
    saved=
    if [ -r "$STATE_FILE" ]; then
        IFS= read -r saved < "$STATE_FILE" || true
    fi

    if [ -n "$saved" ] && [ -f "$saved" ]; then
        printf '%s\n' "$saved"
    else
        printf '%s\n' "$DEFAULT_WALLPAPER"
    fi
}

apply_wallpaper() {
    wallpaper=$1

    if [ ! -f "$wallpaper" ]; then
        printf 'Wallpaper does not exist: %s\n' "$wallpaper" >&2
        return 1
    fi

    swaymsg output '*' bg "$wallpaper" fill >/dev/null

    mkdir -p "$STATE_DIR"
    temporary="$STATE_FILE.$$"
    trap 'rm -f "$temporary"' EXIT HUP INT TERM
    printf '%s\n' "$wallpaper" > "$temporary"
    mv "$temporary" "$STATE_FILE"
    trap - EXIT HUP INT TERM
}

choose_wallpaper() {
    if [ ! -d "$WALLPAPER_DIR" ]; then
        notify-send "壁纸切换失败" "目录不存在：$WALLPAPER_DIR"
        return 1
    fi

    selection=$(
        find "$WALLPAPER_DIR" -maxdepth 1 -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
            -printf '%f\n' | sort | \
            fuzzel --dmenu --prompt='Wallpaper:' --lines=15 --width=60
    ) || return 0

    [ -n "$selection" ] || return 0
    wallpaper="$WALLPAPER_DIR/$selection"

    if apply_wallpaper "$wallpaper"; then
        notify-send "壁纸已切换" "$selection"
    else
        notify-send "壁纸切换失败" "$selection"
        return 1
    fi
}

case "${1:-choose}" in
    choose) choose_wallpaper ;;
    current) current_wallpaper ;;
    restore) apply_wallpaper "$(current_wallpaper)" ;;
    *)
        printf 'Usage: %s [choose|current|restore]\n' "$0" >&2
        exit 2
        ;;
esac
