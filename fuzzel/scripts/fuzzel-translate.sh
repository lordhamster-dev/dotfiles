#! /usr/bin/env sh

# Quick translation utility using `fuzzel` and `translate-shell`

# Dependencies:
# - fuzzel: https://codeberg.org/dnkl/fuzzel (Language selection and text entry)
# - translate-shell: https://github.com/soimort/translate-shell (Translation)

export https_proxy=http://127.0.0.1:7890
export http_proxy=http://127.0.0.1:7890
export all_proxy=socks5://127.0.0.1:7890

text=$(echo "" | fuzzel --dmenu --prompt="Text: " --lines=1)
if [ -z "$text" ]; then exit; fi
trans -b :zh "$text" | fuzzel --dmenu --lines=10
