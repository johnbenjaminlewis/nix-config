#!/usr/bin/env bash
set -eo pipefail

sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller

if ! sudo /nix/nix-installer uninstall; do
  cmd_exit=$?

  echo "If this failes you may need to reload your environment or reboot your computer"
  exit "$cmd_exit"
fi
