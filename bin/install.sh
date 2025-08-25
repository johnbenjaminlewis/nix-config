#!/usr/bin/env bash
set -eo pipefail

# Define the Nix installer URL
NIX_INSTALL_URL="https://github.com/DeterminateSystems/nix-installer"
HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"


open_url() {
  local url=$1

  if [ -z "$PS1" ]; then
    return
  fi

  # Attempt to open the URL using platform-specific commands.
  # 'open' is common on macOS.
  # 'xdg-open' is common on Linux.
  if command -v open &> /dev/null; then
    open "$url"
  elif command -v xdg-open &> /dev/null; then
    xdg-open "$url"
  else
    echo "🚨 Could not find a command to open the URL automatically."
    echo "Please open this URL manually in your web browser:"
    echo "$url"
  fi
}

check_nix() {
    # Check if the 'nix-shell' command exists in the system's PATH.
    # We use 'command -v' which is a reliable way to check for executables.
    if command -v nix-shell &> /dev/null; then
      echo "🎉 Nix is already installed!"
      echo "You can run 'nix-shell --version' to see your Nix version."
    else
      echo "😞 Nix is not found on your system."
      return 1
    fi
}

check_nix_darwin() {
    # Check if the 'nix-shell' command exists in the system's PATH.
    # We use 'command -v' which is a reliable way to check for executables.
    if nix profile list | grep github:nix-darwin &> /dev/null; then
      echo "🎉 nix-darwin is already installed!"
    else
      echo "😞 homebrew is not found on your system."
      return 1
    fi
}

check_homebrew() {
  if which brew &> /dev/null; then
    echo "🎉 homebrew is already installed!"
  else
    return 1
  fi
}

if ! check_nix; then
    echo "Opening the Nix installer URL: ${NIX_INSTALL_URL}"
    open_url "$NIX_INSTALL_URL"
    exit 1
fi

if ! check_nix_darwin; then
    echo "Installing nix-darwin in this profile"
    nix profile install github:nix-darwin/nix-darwin
fi

if ! check_homebrew; then
    echo "Installing Homebrew  in this profile"
    bash -c "$(curl -fsSL "$HOMEBREW_INSTALL_URL")"
fi

echo
echo "You can run 'make build' (or 'sudo darwin-rebuild switch --flake .')"
