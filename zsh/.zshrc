export SHELL="/bin/zsh"

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

# Starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# fzf
eval "$(fzf --zsh)"

# brew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

# PATH
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$HOME/.local/bin:$PATH"

# JAVA
export JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_11_HOME=`/usr/libexec/java_home -v 11`
alias jdk11="export JAVA_HOME=$JAVA_11_HOME"
export JAVA_8_HOME=`/usr/libexec/java_home -v 1.8`
alias jdk8="export JAVA_HOME=$JAVA_8_HOME"

# android
export ANDROID_HOME=/Users/jacob/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/platform-tools
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH="/usr/local/sbin:$PATH:$HOME/.config/bin"

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

## alias for taskwarrior
# alias t="task"
# alias work="task context work"
# alias home="task context home"
# alias none="task context none"
# alias today="task today"


# NVM(node version manager)
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Load Angular CLI autocompletion.
source <(ng completion script)

source ~/.zshrc_private

if [[ -n $TMUX ]]; then
    __kdwithtmuxpopup() {
        tmux display-popup "kd $@"
    }
    alias kd=__kdwithtmuxpopup
fi
