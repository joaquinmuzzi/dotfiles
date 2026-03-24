# TLP: cambio rápido entre ahorro y rendimiento

Se agregaron dos comandos en `bin/`:

- `modo-ahorro`: prioriza duración de batería.
- `modo-rendimiento`: prioriza rendimiento máximo.

## Uso rápido

Desde este repo:

```bash
~/dotfiles/bin/modo-ahorro
~/dotfiles/bin/modo-rendimiento
```

Los scripts:

1. crean backup de `/etc/tlp.conf`,
2. actualizan parámetros de TLP para modo batería,
3. aplican cambios con `sudo tlp bat`.

## Comandos sin ruta (opcional)

### Opción 1: sin sudo (recomendada)

```bash
mkdir -p ~/.local/bin
ln -sf ~/dotfiles/bin/modo-ahorro ~/.local/bin/modo-ahorro
ln -sf ~/dotfiles/bin/modo-rendimiento ~/.local/bin/modo-rendimiento
ln -sf ~/dotfiles/bin/modo-ahorro ~/.local/bin/tlp-bat
ln -sf ~/dotfiles/bin/modo-rendimiento ~/.local/bin/tlp-perf
```

Si `~/.local/bin` no está en tu `PATH`, agregá esto a tu shell:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Opción 2: global con sudo

```bash
sudo ln -sf ~/dotfiles/bin/modo-ahorro /usr/local/bin/modo-ahorro
sudo ln -sf ~/dotfiles/bin/modo-rendimiento /usr/local/bin/modo-rendimiento
sudo ln -sf ~/dotfiles/bin/modo-ahorro /usr/local/bin/tlp-bat
sudo ln -sf ~/dotfiles/bin/modo-rendimiento /usr/local/bin/tlp-perf
```

Después podés ejecutar:

```bash
modo-ahorro
modo-rendimiento
tlp-bat
tlp-perf
```

## Verificación

```bash
sudo tlp-stat -s
sudo tlp-stat -p
```