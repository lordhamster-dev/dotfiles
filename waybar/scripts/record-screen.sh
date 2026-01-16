#!/bin/bash

RECORD_DIR="$HOME/Videos"
PIDFILE="/tmp/wf-recorder.pid"
mkdir -p "$RECORD_DIR"

start_recording() {
    FILENAME="$RECORD_DIR/recording_$(date +%Y%m%d_%H%M%S).mp4"
    wf-recorder -a -g "$(slurp)" -f "$FILENAME" &
    echo $!  > "$PIDFILE"
    notify-send "🔴 开始录屏" "$FILENAME"
}

stop_recording() {
    if [ -f "$PIDFILE" ]; then
        kill -SIGINT "$(cat $PIDFILE)" 2>/dev/null
        rm -f "$PIDFILE"
        notify-send "⏹️ 录屏已停止"
    fi
}

toggle_recording() {
    if [ -f "$PIDFILE" ] && kill -0 "$(cat $PIDFILE)" 2>/dev/null; then
        stop_recording
    else
        start_recording
    fi
}

case "$1" in
    start) start_recording ;;
    stop) stop_recording ;;
    toggle) toggle_recording ;;
    status) [ -f "$PIDFILE" ] && kill -0 "$(cat $PIDFILE)" 2>/dev/null && echo "recording" ;;
    *) toggle_recording ;;
esac
