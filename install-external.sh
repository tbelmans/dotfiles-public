#!/bin/sh
# Installer for everyone except the repo owner: same tools and
# shell/vim/tmux/git setup, but nothing under .ssh/ is linked.
# Picks the macOS or Linux installer automatically. Safe to re-run.
#
#   ./install-external.sh
#   GIT_USER_NAME="Jane Doe" GIT_USER_EMAIL=jane@example.com ./install-external.sh
#
# Plain sh on purpose: the real installers need bash, which Alpine lacks.
set -eu

REPO="$(cd "$(dirname "$0")" && pwd)"

if ! command -v bash >/dev/null 2>&1; then
  if command -v apk >/dev/null 2>&1; then
    echo "==> install    bash"
    if [ "$(id -u)" -eq 0 ]; then apk add --no-cache bash; else sudo apk add --no-cache bash; fi
  else
    echo "bash is required; install it and re-run." >&2
    exit 1
  fi
fi

export DOTFILES_EXTERNAL=1
case "$(uname -s)" in
  Darwin) exec bash "$REPO/install-mac.sh" "$@" ;;
  Linux)  exec bash "$REPO/install-linux.sh" "$@" ;;
  *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac
