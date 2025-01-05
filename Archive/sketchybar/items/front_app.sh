#!/bin/sh

front_app=(
  label.font="$FONT:Bold:14"
  label.padding_left=$PADDINGS
  label.padding_right=$INNER_PADDINGS
  padding_left=10
  icon.background.drawing=on
  display=active
  script="$PLUGIN_DIR/front_app.sh"
  click_script="open -a 'Mission Control'"
)
sketchybar --add item front_app left         \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched

