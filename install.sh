#!/bin/bash

# Detect operating system
OS="$(uname -s)"

# Common symlinks for both systems
create_symlink() {
    local src=$1
    local dest=$2

    # 检查目标是否已经是正确的符号链接
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "Symlink already exists: $dest -> $src"
        return 0
    fi

    # 如果目标存在但不是符号链接，或者指向不同的位置
    if [ -e "$dest" ]; then
        echo "Removing existing file/directory: $dest"
        rm -rf "$dest"
    fi

    # 创建新的符号链接
    echo "Creating symlink: $dest -> $src"
    ln -sf "$src" "$dest"
}

common_links() {
    create_symlink ~/dotfiles/zsh/.zshrc ~/.zshrc
    create_symlink ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh
    create_symlink ~/dotfiles/clash/config.yaml ~/.config/clash/config.yaml
    create_symlink ~/dotfiles/tmux ~/.config/tmux
    create_symlink ~/dotfiles/.gitconfig ~/.gitconfig
    create_symlink ~/dotfiles/nvim ~/.config/nvim
    create_symlink ~/dotfiles/yazi ~/.config/yazi
}

# Mac specific symlinks
mac_links() {
    mkdir -p ~/.config/kitty
    create_symlink ~/dotfiles/kitty/current-theme.conf ~/.config/kitty/current-theme.conf
    create_symlink ~/dotfiles/kitty/macos-kitty.conf ~/.config/kitty/kitty.conf
    create_symlink ~/dotfiles/ghostty ~/.config/ghostty
    create_symlink ~/dotfiles/karabiner/complex_modifications ~/.config/karabiner/assets/complex_modifications
}

# Linux specific symlinks
linux_links() {
    create_symlink ~/dotfiles/zsh/.zprofile ~/.zprofile
    create_symlink ~/dotfiles/fontconfig ~/.config/fontconfig
    create_symlink ~/dotfiles/kitty ~/.config/kitty
    create_symlink ~/dotfiles/ghostty ~/.config/ghostty
    create_symlink ~/dotfiles/hypr ~/.config/hypr
    create_symlink ~/dotfiles/waybar ~/.config/waybar
    create_symlink ~/dotfiles/mako ~/.config/mako
}

# Main installation
echo "Detected OS: $OS"
echo "Creating symlinks..."

# Create common links
common_links

# OS-specific links
case "$OS" in
    Darwin*)
        echo "Setting up Mac configuration..."
        mac_links
        ;;
    Linux*)
        echo "Setting up Linux configuration..."
        linux_links
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

echo "Installation complete!"
