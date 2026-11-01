#!/usr/bin/env bash
# Rebuild the WSL (Ubuntu 24.04) dev environment from this repo.
#
#   git clone https://github.com/kpradeep06ds-star/dotfiles.git ~/dotfiles
#   bash ~/dotfiles/wsl/bootstrap.sh            # run everything
#   bash ~/dotfiles/wsl/bootstrap.sh 20         # run one step (prefix match)
#
# Every step is idempotent: safe to re-run after a failure or on a machine
# that is already set up. Only touches this distro and $HOME.
set -uo pipefail
export GIT_TERMINAL_PROMPT=0

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES
export WSL_DIR="$DOTFILES/wsl"
export BIN="$HOME/.local/bin"
mkdir -p "$BIN" "$HOME/.config" "$HOME/.local/opt"

only="${1:-}"
failed=()
for step in "$WSL_DIR"/scripts/[0-9]*.sh; do
  name="$(basename "$step")"
  [[ -n "$only" && "$name" != "$only"* ]] && continue
  echo
  echo "==================== $name ===================="
  if bash "$step"; then echo "--> $name OK"; else echo "--> $name FAILED"; failed+=("$name"); fi
done

echo
if [ ${#failed[@]} -eq 0 ]; then
  echo "All steps succeeded. Open a new terminal (or: source ~/.bashrc), then: nvim +checkhealth"
else
  echo "Failed steps: ${failed[*]}  (fix, then re-run: bash $WSL_DIR/bootstrap.sh <step-number>)"
  exit 1
fi
