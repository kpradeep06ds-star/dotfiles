# WSL dev environment

Rebuilds my Ubuntu 24.04 (WSL2) setup on any Windows machine so it matches my NixOS
machine. Neovim's `init.lua` (`config/nvim/`) is shared by both; everything else that
NixOS gets from `etc-nixos/configuration.nix` is reproduced here with scripts.

## New machine

1. In PowerShell: `wsl --install -d Ubuntu-24.04`, create the user, open Ubuntu.
2. In Ubuntu:
   ```bash
   git clone https://github.com/kpradeep06ds-star/dotfiles.git ~/dotfiles
   bash ~/dotfiles/wsl/bootstrap.sh
   ```
3. Close and reopen Windows Terminal. In PowerShell: `wsl --shutdown` (applies `.wslconfig`).
4. Check: `nvim +checkhealth`.

Re-running is safe. One step only: `bash ~/dotfiles/wsl/bootstrap.sh 40`.

## Layout

| Path | Purpose |
|---|---|
| `bootstrap.sh` | Entry point. Runs `scripts/NN-*.sh` in order, reports failures. |
| `scripts/10-apt.sh` | Ubuntu packages: build tools + modern CLI (ripgrep, fd, eza, bat, fzf, zoxide, delta, tmux, btop...). |
| `scripts/20-toolchains.sh` | rustup (+ rust-analyzer, clippy), pipx (pyright, ruff), cargo (taplo, starship, yazi via yazi-build). |
| `scripts/30-binaries.sh` | GitHub releases: Neovim (latest stable), lua-language-server, fastfetch, win32yank. |
| `scripts/40-neovim-plugins.sh` | Neovim plugins as native packages (`pack/core/start`) + treesitter parsers. |
| `scripts/50-link-configs.sh` | Symlinks repo configs into `$HOME`; hooks `bashrc.wsl` into `~/.bashrc`; git delta. |
| `scripts/60-windows.sh` | Windows side: Nerd Font (winget), Windows Terminal settings, `.wslconfig`. |
| `home/` | `bashrc.wsl`, `starship.toml`, `tmux.conf` (symlinked, so edits go into git). |
| `windows/` | `terminal-settings.json`, `wslconfig` template. |
| `sync-windows.sh` | Copies live Windows Terminal settings back into the repo. |

## Keeping it in sync

- Configs in `home/` and `config/nvim/` are symlinked, so editing them edits the repo. Just commit.
- Changed Windows Terminal from its Settings UI? Run `bash wsl/sync-windows.sh`, then commit.
- Added a tool? Add it to the right `scripts/NN-*.sh` (apt list, cargo list...), then commit.
- Added a Neovim plugin on NixOS? Add the same repo to `PLUGINS` in `40-neovim-plugins.sh`.

## Rules (for me, and for any LLM editing this)

- **Every script must be idempotent**: re-running on a set-up machine changes nothing harmful.
- **Never delete user files**: move them to `*.bak.<timestamp>` first (see `link()` in step 50).
- **Trusted sources only**, in this order: Ubuntu apt -> official GitHub releases of established
  projects -> `cargo install --locked` / `pipx`. No `curl | sh` except rustup's official installer.
  No new or unproven tools.
- **Don't modify `~/.bashrc` directly** beyond the single `bashrc.wsl` hook line.
- **`init.lua` is shared with NixOS**: no WSL-only changes there; it must keep working on both.
- **Mirror NixOS**: aliases match `programs.bash.shellAliases`, `starship.toml` matches
  `programs.starship.settings`, plugins match `programs.neovim...packages.core.start`.
- Scope: one distro ("Ubuntu", user `warlock`). Other distros (e.g. `Ubuntu-20.04`) are untouched.
- Not covered: `nixd` (needs Nix), anything from the Hyprland desktop.
