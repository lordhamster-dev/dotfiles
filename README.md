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
   sudo pacman -S git vim inetutils iproute2 iputils procps-ng psmisc sysfsutils which wget unzip mtr traceroute dnsutils lsb-release ca-certificates bash-completion logrotate openssh less rsync jq
   ```

   ```bash
   sudo pacman -S hyprpaper hypridle hyprlock hyprpicker hyprland-qtutils waybar flameshot cliphist blueberry brightnessctl rofi-wayland rofi-emoji pavucontrol xorg xorg-xwayland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk polkit-kde-agent qt5-wayland qt6-wayland qt5ct qt6ct nwg-look udiskie pipewire-pulse
   ```

   ```bash
   sudo pacman -S fcitx5-im fcitx5-qt fcitx5-gtk fcitx5-chinese-addons fcitx5-rime
   ```

   ```bash
   sudo pacman -S clash keyd neovim tmux yazi zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions fzf fd ripgrep zoxide btop imagemagick uv gnome-calculator nodejs npm nvm tk mpv obs-studio thunderbird obsidian
   ```

   ```bash
   yay -S rime-ice catppuccin-cursors-mocha catppuccin-gtk-theme-mocha google-chrome-stable zsh-theme-powerlevel10k
   ```

   If have bluetooth enable it

   ```bash
    sudo systemctl enable --now bluetooth
   ```

3. **Apply Configuration**

   ```bash
   ./install.sh
   ```

4. **Change Default Shell**

   ```bash
   chsh -s $(which zsh)
   ```

5. **Input Method Setup**

   ```bash
   vim ~/.local/share/fcitx5/rime/default.custom.yaml
   ```

   Add the following lines to the file:

   ```yaml
   patch:
     # 仅使用「雾凇拼音」的默认配置，配置此行即可
     __include: rime_ice_suggestion:/
     # 以下根据自己所需自行定义
     __patch:
       menu/page_size: 5 #候选词个数
   ```

## Archlinux kvm

```bash
sudo pacman -S qemu-desktop libvirt virt-manager virt-viewer bridge-utils dmidecode dnsmasq swtpm
```

```bash
sudo systemctl enable --now libvirtd virtlogd
```

```bash
sudo virsh net-define /etc/libvirt/qemu/networks/default.xml
```

```bash
sudo virsh net-autostart default
sudo virsh net-start default
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
