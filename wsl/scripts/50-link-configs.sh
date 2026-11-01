#!/usr/bin/env bash
# Symlink configs from the repo into $HOME, so edits land in git.
# Existing real files are moved aside to *.bak.<timestamp>, never deleted.
set -euo pipefail

link() {  # repo_path target
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%s)"; echo "  backup $dst"
  fi
  ln -sfn "$src" "$dst"
  echo "  link $dst -> ${src#$DOTFILES/}"
}

link "$DOTFILES/config/nvim"        "$HOME/.config/nvim"          # shared with NixOS
link "$WSL_DIR/home/starship.toml"  "$HOME/.config/starship.toml"
link "$WSL_DIR/home/tmux.conf"      "$HOME/.tmux.conf"

# Remove the block left by the older one-off setup script (now replaced by bashrc.wsl)
sed -i '/# >>> modern-cli >>>/,/# <<< modern-cli <<</d' "$HOME/.bashrc"

# ~/.bashrc stays Ubuntu's own; we only add one line that sources ours
LINE="[ -f \"$WSL_DIR/home/bashrc.wsl\" ] && . \"$WSL_DIR/home/bashrc.wsl\""
grep -qF "bashrc.wsl" "$HOME/.bashrc" || { printf '\n# dotfiles (WSL)\n%s\n' "$LINE" >> "$HOME/.bashrc"; echo "  hook ~/.bashrc"; }

# git: delta as pager (prettier diffs)
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true

command -v tldr >/dev/null && tldr --update >/dev/null 2>&1 || true
