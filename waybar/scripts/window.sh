#!/bin/bash

# Get active window info (may be empty when no window)
hypr_json=$(hyprctl activewindow -j 2>/dev/null || true)
if [[ -z $hypr_json ]]; then
  jq -cn '{text:"", tooltip:""}'
  exit 0
fi

# Extract class and title (coerce null to empty)
read -r window_class window_title < <(
  jq -r 'if type=="object" then [(.class // ""), (.title // "")] else ["",""] end | @tsv' \
    <<<"$hypr_json" 2>/dev/null || echo -e "\t"
)

# Normalize weird "null" strings
[[ $window_class == "null" ]] && window_class=""
[[ $window_title == "null" ]] && window_title=""
[[ $window_title == "tmux" ]] && window_title="Terminal"
[[ $window_title == "tmux a" ]] && window_title="Terminal"

# Map class to icon
declare -A ICONS=(
  [qq]=""               # QQ
  [wechat]=""           # WeChat
  [firefox]=""          # Firefox
  [chromium]=""         # Chromium
  [chromium-browser]="" # Chromium
  [google-chrome]=""    # Chrome
  [brave]="󰞋"            # Brave Browser
  [kitty]=""            # Kitty terminal
  [alacritty]=""        # Alacritty terminal
  [ghostty]=""          # Ghostty Terminal
  [thunderbird]=""      # Thunderbird
  [code]="󰨞"             # VS Code
  [obsidian]="󰎚"         # Obsidian
  [discord]="󰙯"          # Discord
  [steam]=""            # Steam
  [mpv]="󰎁"              # mpv
  [gimp]=""             # GIMP
  [libreoffice]="󰈙"      # LibreOffice
  [nautilus]=""         # Nautilus
  [org.kde.dolphin]=""  # Dolphin
)
icon=""
if [[ -n $window_class ]]; then
  lc=${window_class,,}
  icon=${ICONS[$lc]:-}
fi

# Build display text
parts=()
[[ -n $icon ]] && parts+=("$icon")
# [[ -n $window_class ]] && parts+=("$window_class:")
[[ -n $window_title ]] && parts+=("$window_title")
text="${parts[*]}"

# Output JSON (escaped)
jq -cn --arg text "$text" --arg tooltip "Class:$window_class Title:$window_title" '{text:$text, tooltip:$tooltip}'
