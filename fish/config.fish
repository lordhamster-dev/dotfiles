set fish_greeting ""

set -gx TERM xterm-256color

# PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH ~/.cargo/bin $PATH
set -gx PATH /usr/local/bin $PATH

# HOMEBREW
set -x HOMEBREW_BOTTLE_DOMAIN "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

# JAVA
set -x JAVA_HOME (/usr/libexec/java_home)
set -x JAVA_11_HOME (/usr/libexec/java_home -v 11)
alias jdk11 'set -x JAVA_HOME $JAVA_11_HOME'
set -x JAVA_8_HOME (/usr/libexec/java_home -v 1.8)
alias jdk8 'set -x JAVA_HOME $JAVA_8_HOME'

# android
set -x ANDROID_HOME /Users/jacob/Library/Android/sdk
set -x PATH $PATH $ANDROID_HOME/platform-tools
set -x PATH $PATH $ANDROID_HOME/tools
set -x PATH /usr/local/sbin $PATH $HOME/.config/bin

# Python
alias pmr='python manage.py runserver'
function nvimvenv
    if test -e .venv/bin/activate.fish
        source .venv/bin/activate.fish
        command nvim $argv
    else
        command nvim $argv
    end
end
alias nvim=nvimvenv
alias vim=nvimvenv

# # zoxide
zoxide init fish | source

# Starship
starship init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end
