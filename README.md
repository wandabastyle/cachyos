# Dotfiles Onboarding (Arch Linux + yay)

This repository manages a personal Linux setup (Wayland + terminal + editor) with GNU Stow and Git submodules.

## 0) Prerequisites

- Arch Linux (or Arch-based distro)
- `yay` installed
- Git SSH access configured (submodules use SSH URLs like `git@github.com:...`)

Quick SSH check:

```bash
ssh -T git@github.com
```

## 1) Install yay (if missing)

Install build prerequisites:

```bash
sudo pacman -S --needed base-devel git
```

Clone and build `yay` from AUR:

```bash
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
```

Verify:

```bash
yay --version
```

## 2) Clone the repo (with submodules)

```bash
git clone --recurse-submodules git@github.com:<your-user>/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
```

If already cloned without submodules:

```bash
git submodule update --init --recursive
```

## 3) Install required tools with yay

```bash
yay -S --needed \
  git stow \
  neovim-git ripgrep fd nodejs python stylua shellcheck shfmt clang \
  lua-language-server nil rust-analyzer basedpyright typescript typescript-language-server \
  lazygit ollama \
  fish starship zoxide eza bat \
  ghostty qutebrowser rofi niri swayidle pcmanfm-qt \
  quickshell niriswitcher \
  playerctl brightnessctl wireplumber pipewire pipewire-pulse \
  pacman-contrib
```

Optional but used by local scripts/config:

```bash
yay -S --needed brave-bin wofi mpv
```

## 4) Deploy dotfiles with GNU Stow

From repo root:

```bash
cd "$HOME/dotfiles"
stow -t "$HOME" .config .local
```

Notes:

- `.stow-local-ignore` excludes repo metadata and `wallpaper` from symlinking.
- Re-run `stow -t "$HOME" .config .local` after updates.

## 5) Sync submodules after pulling updates

```bash
cd "$HOME/dotfiles"
git pull --recurse-submodules
git submodule update --init --recursive --remote
```

## 6) User services/timers

Reload user units:

```bash
systemctl --user daemon-reload
```

Enable the updates counter timer:

```bash
systemctl --user enable --now updates-counter.timer
```

Check status:

```bash
systemctl --user status updates-counter.timer
```

Ollama is used by Neovim/Python commit tooling and is handled there; no manual systemd setup is required in onboarding.

## 7) First-run checks

### Neovim

```bash
nvim
```

Then run health checks inside Neovim:

```vim
:checkhealth
```

### Fish shell

Set fish as default shell if desired:

```bash
chsh -s /usr/bin/fish
```

Open a new terminal and confirm prompt/tools (`starship`, `zoxide`, aliases) load correctly.

### Wayland session tools

Confirm key apps exist:

```bash
command -v niri ghostty rofi qutebrowser qs niriswitcher
```

## 8) Daily maintenance

Update packages:

```bash
yay -Syu
```

Update dotfiles and submodules:

```bash
cd "$HOME/dotfiles"
git pull --recurse-submodules
git submodule update --init --recursive
```

Re-apply links if needed:

```bash
stow -t "$HOME" .config .local
```

## Troubleshooting

- Submodule clone fails:
  - Ensure GitHub SSH key is configured and loaded.
  - Retry: `git submodule sync --recursive && git submodule update --init --recursive`
- Neovim LSP missing:
  - Verify language servers from install list are present.
  - Run `:checkhealth` in Neovim.
