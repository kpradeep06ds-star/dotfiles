#!/usr/bin/env bash
# Copy the LIVE Windows Terminal settings.json back into the repo.
# Run this after changing anything in Windows Terminal, then commit.
set -euo pipefail
WSL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCALAPPDATA_W="$(wslpath "$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')")"
SRC="$LOCALAPPDATA_W/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

cp "$SRC" "$WSL_DIR/windows/terminal-settings.json"
echo "Synced -> wsl/windows/terminal-settings.json"
git -C "$WSL_DIR/.." --no-pager diff --stat -- wsl/windows/terminal-settings.json || true
