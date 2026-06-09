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

create_child_symlinks() {
    local src_dir=$1
    local dest_dir=$2

    mkdir -p "$dest_dir"

    for dest in "$dest_dir"/*; do
        [ -L "$dest" ] || continue

        local target
        target=$(readlink "$dest")

        case "$target" in
            "$src_dir"/*)
                if [ ! -e "$target" ]; then
                    echo "Removing stale symlink: $dest -> $target"
                    rm "$dest"
                fi
                ;;
        esac
    done

    for src in "$src_dir"/*; do
        [ -e "$src" ] || continue
        create_symlink "$src" "$dest_dir/$(basename "$src")"
    done
}

common_links() {
    create_symlink ~/dotfiles/.gitconfig ~/.gitconfig
    create_symlink ~/dotfiles/zsh/.zshrc ~/.zshrc
    create_symlink ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh
    create_symlink ~/dotfiles/tmux ~/.config/tmux
    create_symlink ~/dotfiles/nvim ~/.config/nvim
    create_symlink ~/dotfiles/yazi ~/.config/yazi
    create_symlink ~/dotfiles/task ~/.config/task
    create_symlink ~/dotfiles/agent/skills ~/.pi/agent/skills
    create_child_symlinks ~/dotfiles/agent/skills ~/.codex/skills
    create_symlink ~/dotfiles/agent/pi/extensions ~/.pi/agent/extensions
    create_symlink ~/dotfiles/agent/pi/keybindings.json ~/.pi/agent/keybindings.json
}

sync_links() {
    create_symlink ~/Sync/.zshrc_private ~/.zshrc_private
}

# Mac specific symlinks
mac_links() {
    mkdir -p ~/.config/kitty
    create_symlink ~/dotfiles/kitty/current-theme.conf ~/.config/kitty/current-theme.conf
    create_symlink ~/dotfiles/kitty/macos-kitty.conf ~/.config/kitty/kitty.conf
    create_symlink ~/dotfiles/mac/karabiner/complex_modifications ~/.config/karabiner/assets/complex_modifications
}

# Linux specific symlinks
linux_links() {
    create_symlink ~/dotfiles/zsh/.zprofile ~/.zprofile
    create_symlink ~/dotfiles/fontconfig ~/.config/fontconfig
    create_symlink ~/dotfiles/kitty ~/.config/kitty
    create_symlink ~/dotfiles/sway ~/.config/sway
    create_symlink ~/dotfiles/waybar ~/.config/waybar
    create_symlink ~/dotfiles/mako ~/.config/mako
    create_symlink ~/dotfiles/mpd ~/.config/mpd
    create_symlink ~/dotfiles/ncmpcpp ~/.config/ncmpcpp
    create_symlink ~/dotfiles/fuzzel ~/.config/fuzzel
}

# Main installation
echo "Detected OS: $OS"
echo "Creating symlinks..."

# Create common links
common_links

# Create sync links
sync_links

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
