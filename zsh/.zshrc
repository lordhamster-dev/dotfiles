export SHELL="/bin/zsh"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit

export ZSH="$HOME/.oh-my-zsh"
plugins=(
    poetry
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    web-search
)
source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# OS Detection and specific configurations
case "$(uname -s)" in
    Darwin)
        # macOS specific configurations
        # brew
        export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

        # JAVA
        export JAVA_HOME=$(/usr/libexec/java_home)
        export JAVA_11_HOME=`/usr/libexec/java_home -v 11`
        alias jdk11="export JAVA_HOME=$JAVA_11_HOME"
        export JAVA_8_HOME=`/usr/libexec/java_home -v 1.8`
        alias jdk8="export JAVA_HOME=$JAVA_8_HOME"

        # android
        export ANDROID_HOME=$HOME/Library/Android/sdk
        export PATH=${PATH}:${ANDROID_HOME}/platform-tools
        export PATH=${PATH}:${ANDROID_HOME}/tools

        # NVM
        export NVM_DIR=~/.nvm
        source $(brew --prefix nvm)/nvm.sh
        ;;
    Linux)
        # Linux specific configurations
        # NVM
        source /usr/share/nvm/init-nvm.sh

        # PYENV
        export PYENV_ROOT="$HOME/.pyenv"
        [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
        ;;
esac

# Common configurations for all systems

# Starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# fzf
eval "$(fzf --zsh)"

# PATH
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH:$HOME/.config/bin"

# UV
export UV_DEFAULT_INDEX=https://pypi.tuna.tsinghua.edu.cn/simple

# neovim
export EDITOR=nvim
# neovim with python, auto activate env (need poetry)
function nvimvenv {
  if [[ -e ".venv/bin/activate" ]]; then
    source ".venv/bin/activate"
    command nvim $@
  else
    command nvim $@
  fi
}
alias nvim=nvimvenv
alias vim=nvimvenv

# alias
alias pmr='python manage.py runserver'
alias proxy="export https_proxy=http://127.0.0.1:7890; export http_proxy=http://127.0.0.1:7890; export all_proxy=socks5://127.0.0.1:7890; echo 'HTTP Proxy on'"
alias unproxy="unset https_proxy; unset http_proxy; unset all_proxy; echo 'HTTP Proxy off';"

# Load Angular CLI autocompletion.
if command -v ng &> /dev/null; then
    source <(ng completion script)
fi

source ~/.zshrc_private

if [[ -n $TMUX ]]; then
    __kdwithtmuxpopup() {
        tmux display-popup "kd $@"
    }
    alias kd=__kdwithtmuxpopup
fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/jacob/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
