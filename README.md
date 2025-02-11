# Dotfiles Configuration

This repository contains my personal dotfiles and configuration for various tools and applications. It's designed to work seamlessly on both macOS and Arch Linux systems.

## Features

- Cross-platform support (macOS & Arch Linux)
- Consistent development environment setup
- Easy installation and configuration
- Customized shell, editor, and system settings

## Requirements

- macOS or Arch Linux
- Homebrew (macOS)
- pacman/yay (Arch Linux)
- Git

## Installation

### macOS Setup

1. **Install Required Fonts**

   ```bash
   brew tap homebrew/cask-fonts
   brew install --cask font-caskaydia-cove-nerd-font
   ```

2. **Install Packages**

   ```bash
   brew bundle
   ```

3. **Apply Configuration**
   ```bash
   ./install.sh
   ```

### Arch Linux Setup

1. **Install Required Fonts**

   ```bash
   sudo pacman -S ttf-cascadia-code-nerd
   ```

2. **Install Packages**

   ```bash
   sudo pacman -S tk pyenv clash neovim starship tmux yazi zsh fzf fd ripgrep zoxide keyd btop cliphist mpv obs-studio hyprpaper hyprlock hyprland-qtutils rofi rofi-emoji waybar pavucontrol
   yay -S hyprshot
   ```

3. **Apply Configuration**

   ```bash
   ./install.sh
   ```

4. **Change Default Shell**
   ```bash
   chsh -s $(which zsh)
   ```

## Included Configurations

- Shell: Zsh with custom prompt and aliases
- Editor: Neovim with plugins and custom settings
- Terminal: Kitty with themes and keybindings
- Window Manager: Hyprland (Linux) / Aerospace (macOS)
- System Utilities: Various productivity tools

## Maintenance

To update your configuration:

```bash
git pull origin main
./install.sh
```

## Contributing

While this is primarily a personal configuration repository, suggestions and improvements are welcome. Please open an issue or submit a pull request.

## Acknowledgments

- Inspired by various dotfiles repositories in the community
- Special thanks to the open source community for creating these amazing tools
