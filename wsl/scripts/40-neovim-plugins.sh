#!/usr/bin/env bash
# Neovim plugins as native packages - the same mechanism as NixOS
# programs.neovim.configure.packages.core.start, so init.lua is shared unchanged.
# Keep this list in sync with etc-nixos/configuration.nix.
set -euo pipefail
PACK="$HOME/.local/share/nvim/site/pack/core/start"
mkdir -p "$PACK"

PLUGINS=(
  nvim-lua/plenary.nvim
  nvim-telescope/telescope.nvim
  neovim/nvim-lspconfig
  nvim-tree/nvim-web-devicons
  lewis6991/gitsigns.nvim
  nvim-lualine/lualine.nvim
  akinsho/bufferline.nvim
  lukas-reineke/indent-blankline.nvim
  folke/which-key.nvim
  "nvim-treesitter/nvim-treesitter master"   # master = classic :TSInstall
)

for entry in "${PLUGINS[@]}"; do
  read -r repo branch <<<"$entry"
  dir="$PACK/$(basename "$repo")"
  if [ -d "$dir" ]; then git -C "$dir" pull --ff-only -q
  else git clone -q --depth 1 ${branch:+-b "$branch"} "https://github.com/$repo.git" "$dir"; fi
  echo "  ok   $repo"
done

# Treesitter parsers (vim, vimdoc, lua ship with Neovim)
"$BIN/nvim" --headless -c "TSInstallSync! bash json nix python rust toml" -c "qa"
