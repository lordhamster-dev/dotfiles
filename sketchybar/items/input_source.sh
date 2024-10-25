#!/bin/sh

sketchybar --add item input_source right
sketchybar --set input_source \
    icon.font="$FONT:Regular:20.0" \
    icon.color=0xffffffff \
    script="$PLUGIN_DIR/get_input_source.sh" \
    update_freq=1


