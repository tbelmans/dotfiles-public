#!/usr/bin/env bash
# Bootstrap a Linux box: CLI tools from the distro, then link the dotfiles.
# Supports apt (Debian/Ubuntu), dnf (Fedora/RHEL), pacman (Arch),
# zypper (openSUSE) and apk (Alpine). Safe to re-run.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$REPO/install/common.sh"

[[ "$(uname -s)" == Linux ]] || { echo "This is the Linux installer; use install-mac.sh" >&2; exit 1; }

SUDO=""
if [[ $EUID -ne 0 ]]; then
  command -v sudo >/dev/null 2>&1 || { echo "sudo is required (or run as root)" >&2; exit 1; }
  SUDO=sudo
fi

PKGS=(git zsh vim tmux curl cpio ripgrep)

log "install    ${PKGS[*]}"
if command -v apt-get >/dev/null 2>&1; then
  $SUDO apt-get update -y
  $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y "${PKGS[@]}"
elif command -v dnf >/dev/null 2>&1; then
  $SUDO dnf install -y "${PKGS[@]}"
elif command -v pacman >/dev/null 2>&1; then
  $SUDO pacman -Sy --needed --noconfirm "${PKGS[@]}"
elif command -v zypper >/dev/null 2>&1; then
  $SUDO zypper --non-interactive install "${PKGS[@]}"
elif command -v apk >/dev/null 2>&1; then
  $SUDO apk add --no-cache "${PKGS[@]}" bash shadow
else
  echo "No supported package manager found; install ${PKGS[*]} manually and re-run." >&2
  exit 1
fi

run_common
