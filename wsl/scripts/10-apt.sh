#!/usr/bin/env bash
# System packages from Ubuntu's signed repositories (vetted, tested builds).
set -uo pipefail

PACKAGES=(
  # build + basics
  git curl unzip tar build-essential pipx
  # modern CLI
  ripgrep fd-find eza bat fzf zoxide git-delta jq tree
  tmux btop htop ncdu duf tealdeer
)

sudo apt update
failed=()
for pkg in "${PACKAGES[@]}"; do
  if sudo apt install -y "$pkg" >/dev/null 2>&1; then echo "  ok   $pkg"
  else echo "  FAIL $pkg"; failed+=("$pkg"); fi
done

# Ubuntu renames two binaries; restore the usual names
ln -sf /usr/bin/batcat "$BIN/bat"
ln -sf /usr/bin/fdfind "$BIN/fd"

[ ${#failed[@]} -eq 0 ] || { echo "Failed: ${failed[*]}"; exit 1; }
