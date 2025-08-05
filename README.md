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
   sudo pacman -S git vi vim inetutils iproute2 iputils procps-ng psmisc sysfsutils which wget unzip mtr traceroute dnsutils lsb-release ca-certificates bash-completion logrotate openssh less rsync sdl2_ttf sdl2_image
   ```

   ```bash
   sudo pacman -S tk clash neovim tmux yazi zsh fzf fd ripgrep zoxide keyd btop cliphist hyprpaper hyprlock hyprland-qtutils rofi rofi-emoji waybar pavucontrol imagemagick uv
   ```

   ```bash
   sudo pacman -S nodejs npm nvm brightnessctl
   ```

   ```bash
   yay -S hyprshot xorg xorg-xwayland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk polkit-kde-agent qt5-wayland qt6-wayland qt5ct qt6ct nwg-look udiskie
   ```

   ```bash
   yay -S fcitx5-im fcitx5-pinyin-zhwiki fcitx5-qt fcitx5-gtk fcitx5-chinese-addons
   ```

3. **Install Apps**

   ```bash
   yay -S google-chrome-stable
   ```

   ```bash
   sudo pacman -S mpv obs-studio thunderbird

   ```

4. **Apply Configuration**

   ```bash
   ./install.sh
   ```

5. **Change Default Shell**

   ```bash
   chsh -s $(which zsh)
   ```

## Archlinux kvm

```bash
sudo pacman -S qemu-desktop libvirt virt-manager virt-viewer bridge-utils dmidecode dnsmasq
```

```bash
sudo systemctl enable --now libvirtd virtlogd
```

```bash
sudo usermod -aG libvirt $(whoami)
sudo usermod -aG kvm $(whoami)
```

```bash
virt-manager
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
