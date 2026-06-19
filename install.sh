#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

echo "Dotfiles directory: $DOTFILES_DIR"

# --- Dependencies check ---
echo ""
echo "Checking required packages..."
REQUIRED_PKGS=(git stow alacritty bspwm sxhkd polybar picom dunst feh flameshot rofi starship neovim)
MISSING=()

for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v "$pkg" &>/dev/null && ! pacman -Qi "$pkg" &>/dev/null 2>&1; then
        MISSING+=("$pkg")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo "Missing packages: ${MISSING[*]}"
    echo "Install with: sudo pacman -S ${MISSING[*]}"
    echo ""
    read -p "Continue anyway? [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || exit 1
fi

# --- Symlink function ---
link_file() {
    local src="$1"
    local dst="$2"

    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        echo "  Backing up existing $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    echo "  Linked: $dst -> $src"
}

echo ""
echo "Creating symlinks..."

# Shell
echo "[Shell]"
link_file "$DOTFILES_DIR/bash/.bashrc" "$HOME_DIR/.bashrc"

# Git
echo "[Git]"
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME_DIR/.gitconfig"

# Xorg
echo "[Xorg]"
link_file "$DOTFILES_DIR/xorg/.xinitrc" "$HOME_DIR/.xinitrc"
if [ -f "$DOTFILES_DIR/xorg/.Xresources" ]; then
    link_file "$DOTFILES_DIR/xorg/.Xresources" "$HOME_DIR/.Xresources"
fi

# Terminal - Alacritty
echo "[Alacritty]"
link_file "$DOTFILES_DIR/alacritty/alacritty.toml" "$HOME_DIR/.config/alacritty/alacritty.toml"

# Window Manager - BSPWM
echo "[BSPWM]"
link_file "$DOTFILES_DIR/bspwm/bspwmrc" "$HOME_DIR/.config/bspwm/bspwmrc"
link_file "$DOTFILES_DIR/bspwm/monitors.sh" "$HOME_DIR/.config/bspwm/monitors.sh"

# Hotkeys - sxhkd
echo "[sxhkd]"
link_file "$DOTFILES_DIR/sxhkd/sxhkdrc" "$HOME_DIR/.config/sxhkd/sxhkdrc"

# Bar - Polybar
echo "[Polybar]"
link_file "$DOTFILES_DIR/polybar/config.ini" "$HOME_DIR/.config/polybar/config.ini"
link_file "$DOTFILES_DIR/polybar/launch.sh" "$HOME_DIR/.config/polybar/launch.sh"
link_file "$DOTFILES_DIR/polybar/volume.sh" "$HOME_DIR/.config/polybar/volume.sh"
link_file "$DOTFILES_DIR/polybar/scripts/battery_alert.sh" "$HOME_DIR/.config/polybar/scripts/battery_alert.sh"
link_file "$DOTFILES_DIR/polybar/scripts/temp.sh" "$HOME_DIR/.config/polybar/scripts/temp.sh"

# Compositor - picom
echo "[Picom]"
link_file "$DOTFILES_DIR/picom/picom.conf" "$HOME_DIR/.config/picom/picom.conf"

# Notifications - dunst
echo "[Dunst]"
link_file "$DOTFILES_DIR/dunst/dunstrc" "$HOME_DIR/.config/dunst/dunstrc"

# Prompt - starship
echo "[Starship]"
link_file "$DOTFILES_DIR/starship/starship.toml" "$HOME_DIR/.config/starship.toml"

# File manager - yazi
echo "[Yazi]"
link_file "$DOTFILES_DIR/yazi/yazi.toml" "$HOME_DIR/.config/yazi/yazi.toml"

# Monitor - btop
echo "[btop]"
link_file "$DOTFILES_DIR/btop/btop.conf" "$HOME_DIR/.config/btop/btop.conf"

# Neovim
echo "[Neovim]"
mkdir -p "$HOME_DIR/.config/nvim/lua/config" "$HOME_DIR/.config/nvim/lua/plugins"
for f in "$DOTFILES_DIR/nvim/"*; do
    fname="$(basename "$f")"
    [ "$fname" = "lua" ] && continue
    link_file "$f" "$HOME_DIR/.config/nvim/$fname"
done
for f in "$DOTFILES_DIR/nvim/lua/config/"*; do
    link_file "$f" "$HOME_DIR/.config/nvim/lua/config/$(basename "$f")"
done
for f in "$DOTFILES_DIR/nvim/lua/plugins/"*; do
    link_file "$f" "$HOME_DIR/.config/nvim/lua/plugins/$(basename "$f")"
done

# Scripts (add to PATH)
echo "[Scripts]"
mkdir -p "$HOME_DIR/.local/bin"
for script in "$DOTFILES_DIR/scripts/"*; do
    link_file "$script" "$HOME_DIR/.local/bin/$(basename "$script")"
    chmod +x "$script" 2>/dev/null || true
done
if ! grep -q 'dotfiles/bin' "$HOME_DIR/.bashrc" 2>/dev/null; then
    echo '' >> "$HOME_DIR/.bashrc"
    echo '# dotfiles scripts' >> "$HOME_DIR/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME_DIR/.bashrc"
    echo "  Added ~/.local/bin to PATH in .bashrc"
fi

# Systemd user services
echo "[Systemd]"
if [ -d "$HOME_DIR/.config/systemd/user" ] || mkdir -p "$HOME_DIR/.config/systemd/user"; then
    link_file "$DOTFILES_DIR/systemd/i2c-touchpad-pm-fix.service" \
        "$HOME_DIR/.config/systemd/user/i2c-touchpad-pm-fix.service"
    echo "  Enable with: systemctl --user enable --now i2c-touchpad-pm-fix"
fi

# Taskwarrior
if [ -f "$DOTFILES_DIR/.taskrc" ]; then
    echo "[Taskwarrior]"
    link_file "$DOTFILES_DIR/.taskrc" "$HOME_DIR/.taskrc"
fi

echo ""
echo "Done! Restart your shell or run:"
echo "  source ~/.bashrc"
echo ""
echo "For BSPWM: log out and log back in, or run:"
echo "  bspc wm -r"
