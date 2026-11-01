# Notes for AI assistants

This repo holds two setups that share one Neovim config:

- **NixOS** (Hyprland desktop): `etc-nixos/configuration.nix` + `config/`.
- **WSL / Ubuntu 24.04**: `wsl/` — read `wsl/README.md` first; its "Rules" section is binding.

To rebuild WSL on a new machine: `bash ~/dotfiles/wsl/bootstrap.sh`.
When changing tools, aliases, prompt or Neovim plugins, keep both setups in sync.
