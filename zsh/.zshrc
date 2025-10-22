# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------
# Zsh configuration
# -----------------
export SHELL="/bin/zsh"
source ~/.zshrc_private

# History
HISTFILE=~/.zsh_history
# 设置在当前会话（内存）中保留的历史记录条数
HISTSIZE=1000
# 设置在历史文件中永久保存的条数
SAVEHIST=1000

# 新的命令会追加到文件末尾，而不是覆盖整个文件
setopt APPEND_HISTORY

# 每执行一条命令后，立即将其写入历史文件
# 这样即使终端意外关闭，历史也不会丢失
setopt INC_APPEND_HISTORY

# 在多个打开的终端之间实时共享历史记录
# 在A终端输入的命令，可以立刻在B终端按“上箭头”找到
setopt SHARE_HISTORY

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# OS Detection and specific configurations
case "$(uname -s)" in
    Darwin)
        # macOS specific configurations
        source ~/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
        source ~/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
        source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
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
        source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        # NVM
        source /usr/share/nvm/init-nvm.sh
        ;;
esac

# Common configurations for all systems

# Load Angular CLI autocompletion.
if command -v ng &> /dev/null; then
    source <(ng completion script)
fi

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
# neovim with python, auto activate env
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
alias ll='exa --icons -l'
alias pmr='python manage.py runserver'
alias proxy="export https_proxy=http://127.0.0.1:7890; export http_proxy=http://127.0.0.1:7890; export all_proxy=socks5://127.0.0.1:7890; echo 'HTTP Proxy on'"
alias unproxy="unset https_proxy; unset http_proxy; unset all_proxy; echo 'HTTP Proxy off';"
alias ff="fastfetch"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
