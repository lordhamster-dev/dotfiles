#!/bin/bash

source "$CONFIG_DIR/icons.sh"

DAY_OF_WEEK=$(date '+%w')

case $DAY_OF_WEEK in
  0) DAY_OF_WEEK="日" ;;
  1) DAY_OF_WEEK="一" ;;
  2) DAY_OF_WEEK="二" ;;
  3) DAY_OF_WEEK="三" ;;
  4) DAY_OF_WEEK="四" ;;
  5) DAY_OF_WEEK="五" ;;
  6) DAY_OF_WEEK="六" ;;
esac

sketchybar --set "$NAME" label="$(date '+%Y/%m/%d') 星期$DAY_OF_WEEK $TIME$(date '+%H:%M')"
