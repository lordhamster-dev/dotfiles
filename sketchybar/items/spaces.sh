#!/bin/sh

# Destroy space on right click, focus space on left click.
# New space by left clicking separator (>)

sketchybar --add event aerospace_workspace_change

for m in $(aerospace list-monitors | awk '{print $1}'); do
  for i in $(aerospace list-workspaces --monitor $m); do
    sid=$i
    space=(
      space="$sid"
      icon="$sid"
      icon.highlight_color=$RED
      icon.padding_left=10
      icon.padding_right=10
      display=$m
      padding_left=2
      padding_right=2
      # label.padding_right=20
      # label.color=$GREY
      # label.highlight_color=$WHITE
      # label.font="sketchybar-app-font:Regular:16.0"
      # label.y_offset=-1
      background.color=$BACKGROUND_1
      background.border_color=$BACKGROUND_2
      click_script="aerospace workspace $sid" \
      script="$CONFIG_DIR/plugins/aerospace.sh $sid"
    )

    sketchybar --add space space.$sid left \
               --set space.$sid "${space[@]}" \
               --subscribe space.$sid aerospace_workspace_change
  done
done

# sketchybar --add bracket spaces '/space\..*/' \
#            --set spaces \
#                  background.color=$BLACK \
#                  background.corner_radius=15 \
#                  background.border_width=1 \
#                  background.border_color=$BLUE \
#                  blur_radius=2 \
#                  background.height=30



space_creator=(
  icon=􀆊
  icon.font="$FONT:Bold:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  display=active
  icon.color=$WHITE
)

sketchybar --add item space_creator left               \
           --set space_creator "${space_creator[@]}"   \
           --subscribe space_creator aerospace_workspace_change

