# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lordhamster/.zshrc'

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

# Starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# fzf
eval "$(fzf --zsh)"

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
source /usr/share/nvm/init-nvm.sh

# Load Angular CLI autocompletion.
# source <(ng completion script)

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
