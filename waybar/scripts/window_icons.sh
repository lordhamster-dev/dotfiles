#!/bin/bash
window_class=$(hyprctl activewindow -j | jq -r '.class')

case "$window_class" in
  firefox)
    echo ""
    ;;
  code)
    echo ""
    ;;
  terminal)
    echo ""
    ;;
  spotify)
    echo ""
    ;;
  *)
    echo ""  # Default icon
    ;;
esac
