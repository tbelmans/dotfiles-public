#!/usr/bin/env bash
# Bootstrap a Mac: Homebrew, CLI tools, fonts, then link the dotfiles.
# Safe to re-run.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$REPO/install/common.sh"

[[ "$(uname -s)" == Darwin ]] || { echo "This is the macOS installer; use install-linux.sh" >&2; exit 1; }

if ! xcode-select -p >/dev/null 2>&1; then
  log "install    Xcode Command Line Tools"
  xcode-select --install
  echo "Finish the Command Line Tools install in the dialog, then re-run this script."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    log "install    Homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  fi
fi

log "brew       formulae"
brew install git zsh vim tmux curl ripgrep
log "brew       casks"
brew install --cask ghostty font-jetbrains-mono-nerd-font || \
  echo "warning: cask install failed (already installed outside brew?)"

run_common
