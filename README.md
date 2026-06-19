# dotfiles

Backup de configuraciones de Arch Linux (BSPWM + Polybar + Alacritty + Neovim).

## Estructura

```
.
├── install.sh          # Script de instalación (symlinks)
├── alacritty/          # Terminal emulator
├── bash/               # Shell config (oh-my-bash)
├── bspwm/              # Window manager
├── dunst/              # Notificaciones
├── git/                # Git config
├── nvim/               # Neovim (LazyVim)
├── picom/              # Compositor
├── polybar/            # Status bar
├── scripts/            # Scripts personales
├── starship/           # Shell prompt
├── sxhkd/              # Hotkeys
├── systemd/            # Systemd user services
├── xorg/               # Xinitrc, Xresources
└── yazi/               # File manager
```

## Instalación

```bash
git clone <url> ~/repos/dotfiles
cd ~/repos/dotfiles
chmod +x install.sh
./install.sh
```

## Restaurar después de instalar Windows

1. Instalar Arch Linux (mínimo)
2. Instalar paquetes base:
   ```bash
   sudo pacman -S git stow alacritty bspwm sxhkd polybar picom dunst feh flameshot rofi starship neovim
   ```
3. Clonar este repo:
   ```bash
   git clone <url> ~/repos/dotfiles
   ```
4. Ejecutar install.sh
5. Reinstalar GRUB para dual boot:
   ```bash
   sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ``## Paquetes instalados

Verificar con:
```bash
pacman -Qq | sort > installed-packages.txt
```

Para reinstalar todo:
```bash
sudo pacman -S --needed - < installed-packages.txt
```

## Personalización

- Los colores usan el tema Tokyo Night
- BSPWM usa 10 workspaces
- Polybar muestra: bateria, temperatura, volumen, wifi, fecha
- El wallpaper está en `~/wallpapers/`
