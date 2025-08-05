#!/bin/bash
# 获取当前活动窗口的类名和标题
window_info=$(hyprctl activewindow -j)
window_class=$(echo "$window_info" | jq -r '.class')
# window_title=$(echo "$window_info" | jq -r '.title')

# 根据窗口类名映射图标
case "$window_class" in
  firefox)
    icon=""
    title=$window_class
    ;;
  kitty)
    icon=""
    title=$window_class
    ;;
  obsidian)
    icon="󰎚"
    title=$window_class
    ;;
  wechat)
    icon=""
    title=$window_class
    ;;
  steam)
    icon=""
    title=$window_class
    ;;
  null)
    icon=""
    title=""
    ;;
  *)
    icon="󰣆"
    title=$window_class
    ;;
esac

echo "$icon $title"
