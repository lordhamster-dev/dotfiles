#!/bin/bash
# 获取当前活动窗口的类名和标题
window_info=$(hyprctl activewindow -j)
window_class=$(echo "$window_info" | jq -r '.class')
# window_title=$(echo "$window_info" | jq -r '.title')

# 根据窗口类名映射图标
case "$window_class" in
  firefox)
    icon=""
    ;;
  kitty)
    icon=""
    ;;
  obsidian)
    icon="󰎚"
    ;;
  wechat)
    icon=""
    ;;
  steam)
    icon=""
    ;;
  *)
    icon="󰣆"
    ;;
esac

echo "$icon $window_class"
