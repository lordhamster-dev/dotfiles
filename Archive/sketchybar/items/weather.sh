#!/bin/sh

sketchybar --add item weather right \
  --set weather \
  icon=$WEATHER \
  icon.font="$FONT:Bold:20" \
  icon.padding_left=$INNER_PADDINGS \
  label.padding_right=$INNER_PADDINGS \
  script="$PLUGIN_DIR/weather.sh" \
  update_freq=1500 \
  --subscribe weather mouse.clicked

