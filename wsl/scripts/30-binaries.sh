#!/usr/bin/env bash
# Tools not in Ubuntu 24.04 repos (or too old there): official GitHub releases.
set -euo pipefail
OPT="$HOME/.local/opt"

# Neovim - latest stable (apt's version is too old for vim.lsp.config, needs 0.11+)
curl -fsSL -o /tmp/nvim.tar.gz \
  https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
rm -rf "$OPT/nvim-linux-x86_64"
tar -xzf /tmp/nvim.tar.gz -C "$OPT"
ln -sf "$OPT/nvim-linux-x86_64/bin/nvim" "$BIN/nvim"
echo "  ok   neovim $("$BIN/nvim" --version | head -1)"

# lua-language-server
url=$(curl -fsSL https://api.github.com/repos/LuaLS/lua-language-server/releases/latest \
  | grep -o 'https://[^"]*linux-x64\.tar\.gz' | head -1)
rm -rf "$OPT/lua-language-server" && mkdir -p "$OPT/lua-language-server"
curl -fsSL "$url" | tar -xz -C "$OPT/lua-language-server"
ln -sf "$OPT/lua-language-server/bin/lua-language-server" "$BIN/lua-language-server"
echo "  ok   lua-language-server"

# fastfetch
curl -fsSL -o /tmp/fastfetch.deb \
  https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb
sudo apt install -y /tmp/fastfetch.deb >/dev/null
echo "  ok   fastfetch"

# win32yank - Neovim <-> Windows clipboard bridge (clipboard=unnamedplus)
curl -fsSL -o /tmp/win32yank.zip \
  https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
unzip -o -q /tmp/win32yank.zip win32yank.exe -d "$BIN" && chmod +x "$BIN/win32yank.exe"
echo "  ok   win32yank"
