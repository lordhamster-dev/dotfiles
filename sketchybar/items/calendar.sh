#!/bin/bash

calendar=(
  icon=$CALENDAR
  icon.font="$FONT:Bold:20"
  icon.padding_left=$INNER_PADDINGS
  label.padding_right=$INNER_PADDINGS
  label.align=right
  update_freq=30
  script="$PLUGIN_DIR/calendar.sh"
  click_script="$PLUGIN_DIR/zen.sh"
)

sketchybar --add item calendar right       \
           --set calendar "${calendar[@]}" \
           --subscribe calendar system_woke
