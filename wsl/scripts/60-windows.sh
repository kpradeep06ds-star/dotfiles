#!/usr/bin/env bash
# Windows-side setup, driven from inside WSL:
#   - JetBrainsMono Nerd Font (Windows Terminal renders WSL text with Windows fonts)
#   - Windows Terminal settings.json   (Catppuccin theme, Ubuntu profile)
#   - %USERPROFILE%\.wslconfig          (only if none exists)
# Existing Windows files are backed up before being replaced.
set -uo pipefail

winenv() { cmd.exe /c "echo %$1%" 2>/dev/null | tr -d '\r'; }
LOCALAPPDATA_W="$(wslpath "$(winenv LOCALAPPDATA)")"
USERPROFILE_W="$(wslpath "$(winenv USERPROFILE)")"
WT_DIR="$LOCALAPPDATA_W/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"

# 1. Font
if winget.exe list --id DEVCOM.JetBrainsMonoNerdFont 2>/dev/null | tr -d '\r' | grep -q JetBrainsMono; then
  echo "  ok   font already installed"
else
  winget.exe install --id DEVCOM.JetBrainsMonoNerdFont -e \
    --accept-source-agreements --accept-package-agreements \
    && echo "  ok   font installed (restart Windows Terminal)" \
    || echo "  WARN font install failed - install JetBrainsMono Nerd Font manually"
fi

# 2. Windows Terminal settings
if [ -d "$WT_DIR" ]; then
  if ! cmp -s "$WSL_DIR/windows/terminal-settings.json" "$WT_DIR/settings.json"; then
    [ -f "$WT_DIR/settings.json" ] && cp "$WT_DIR/settings.json" "$WT_DIR/settings.json.bak.$(date +%s)"
    cp "$WSL_DIR/windows/terminal-settings.json" "$WT_DIR/settings.json"
    echo "  ok   Windows Terminal settings applied (old one backed up)"
  else
    echo "  ok   Windows Terminal settings already up to date"
  fi
else
  echo "  WARN Windows Terminal not found - install it from the Microsoft Store, then re-run step 60"
fi

# 3. .wslconfig (takes effect after: wsl --shutdown, from PowerShell)
if [ -f "$USERPROFILE_W/.wslconfig" ]; then
  echo "  ok   .wslconfig exists - left untouched (template: wsl/windows/wslconfig)"
else
  cp "$WSL_DIR/windows/wslconfig" "$USERPROFILE_W/.wslconfig"
  echo "  ok   .wslconfig created - run 'wsl --shutdown' in PowerShell to apply"
fi
