#!/bin/sh

wifi=(
  icon=$WIFI_CONNECTED
  icon.padding_left=$INNER_PADDINGS
  label.padding_right=$INNER_PADDINGS
  label.align=right
  script="$PLUGIN_DIR/wifi.sh" 
)

sketchybar --add item wifi right \
           --set wifi "${wifi[@]}" \
            update_freq=1800 \
            --subscribe wifi mouse.clicked
