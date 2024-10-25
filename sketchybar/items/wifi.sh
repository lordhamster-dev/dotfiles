#!/bin/sh

wifi=(
  icon=󰖩
  icon.font="$FONT:Bold:20.0"
  icon.padding_right=0
  label.align=right
  script="$PLUGIN_DIR/wifi.sh" 
)

sketchybar --add item wifi right \
           --set wifi "${wifi[@]}"


