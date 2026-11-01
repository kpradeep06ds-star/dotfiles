#!/usr/bin/env bash
# Rust (rustup) and Python CLI tools (pipx). Language servers live here too.
set -uo pipefail

# Rust toolchain + rust-analyzer/clippy/rustfmt
if ! command -v rustup >/dev/null && [ ! -x "$HOME/.cargo/bin/rustup" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
. "$HOME/.cargo/env"
rustup component add rust-analyzer clippy rustfmt

# Python tooling (isolated venvs via pipx)
pipx install pyright || pipx upgrade pyright
pipx install ruff    || pipx upgrade ruff

# Cargo-built tools (crates.io, --locked = exact dependency versions)
for crate in taplo-cli starship; do
  cargo install --locked "$crate"
done

# yazi: its crates.io packages must be built through the yazi-build wrapper
# (installs both `yazi` and `ya`). Plain `cargo install yazi-fm` fails by design.
cargo install --locked --force yazi-build
