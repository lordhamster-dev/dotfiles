if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  export XIM=fcitx;
  export XIM_PROGRAM=fcitx;
  export INPUT_METHOD=fcitx;
  export # GTK_IM_MODULE=fcitx;
  export QT_IM_MODULE=fcitx;
  export XMODIFIERS=@im=fcitx;
  export SDL_IM_MODULE=fcitx;
  export QT_QPA_PLATFORMTHEME=qt6ct;

  export XDG_SESSION_TYPE=wayland;
  export XDG_CURRENT_DESKTOP=sway;                                                                                                                                                                                                                                                                                   ─╯
  export XDG_SESSION_DESKTOP=sway;
  exec sway
fi
