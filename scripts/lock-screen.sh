#!/bin/sh

set -eu

WALLPAPER=$("$HOME/dotfiles/scripts/fuzzel-wallpaper.sh" current)

exec swaylock -f \
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
