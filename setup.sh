#!/usr/bin/env bash
# Symlink every tracked dotfile from this repo into $HOME.
#
# - Links individual files, not whole directories, so private files that
#   are not in the repo (SSH keys, known_hosts, vim plugins) stay as real
#   files in $HOME.
# - If a parent directory in $HOME is itself a symlink (old layout, e.g.
#   ~/.ssh -> ~/dotfiles/.ssh), it is first turned into a real directory
#   with a copy of its contents.
# - Existing files are moved to <file>.bak.<timestamp>, never deleted.
# - With DOTFILES_EXTERNAL=1 (set by install-external.sh), files under
#   .ssh/ are not linked.
#
# Safe to re-run.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

# Files in the repo that are not dotfiles to install.
skip() {
  case "$1" in
    setup.sh|install-*.sh|install/*|.gitignore|README.md) return 0 ;;
  esac
  return 1
}

# Replace a symlinked directory with a real copy of what it points to.
materialize() {
  local dir="$1" src tmp
  src="$(cd "$dir" && pwd -P)"
  tmp="$dir.materialize.$$"
  echo "materialize $dir (was -> $src)"
  mkdir -p "$tmp"
  # Copy contents, skipping sockets (e.g. stale ssh-agent sockets).
  (cd "$src" && find . ! -type s -print0 | cpio -0pdm --quiet "$tmp")
  if [[ "$(uname -s)" == Darwin ]]; then
    chmod "$(stat -f %Lp "$src")" "$tmp"
  else
    chmod "$(stat -c %a "$src")" "$tmp"
  fi
  rm "$dir"
  mv "$tmp" "$dir"
}

# Make sure every parent directory of $1 (relative to $HOME) is a real dir.
ensure_parents() {
  local rel="$1" path="$HOME" part
  local IFS=/
  local parts=($(dirname "$rel"))
  for part in "${parts[@]}"; do
    [[ -z "$part" || "$part" == "." ]] && continue
    path="$path/$part"
    if [[ -L "$path" && -d "$path" ]]; then
      materialize "$path"
    elif [[ ! -e "$path" ]]; then
      mkdir -p "$path"
    fi
  done
}

# Files to link: what git tracks, or everything (minus .git and vim plugins)
# when the repo was downloaded as an archive instead of cloned.
list_files() {
  if git -C "$REPO" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$REPO" ls-files -z
  else
    find . \( -name .git -o -path ./.vim/plugged -o -path ./.vim/pack \) -prune \
      -o \( -type f -o -type l \) ! -name .DS_Store -print0
  fi
}

cd "$REPO"
list_files | while IFS= read -r -d '' rel; do
  rel="${rel#./}"
  skip "$rel" && continue
  if [[ "${DOTFILES_EXTERNAL:-0}" == 1 && "$rel" == .ssh/* ]]; then
    continue
  fi
  src="$REPO/$rel"
  dst="$HOME/$rel"

  # macOS keeps app config under ~/Library; Linux uses XDG paths.
  if [[ "$(uname -s)" != Darwin ]]; then
    case "$rel" in
      "Library/Application Support/com.mitchellh.ghostty/config")
        rel=".config/ghostty/config"; dst="$HOME/$rel" ;;
      Library/*) continue ;;
    esac
  fi

  ensure_parents "$rel"

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    continue
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    echo "backup     $dst -> $dst.bak.$TS"
    mv "$dst" "$dst.bak.$TS"
  fi
  ln -s "$src" "$dst"
  echo "link       $dst -> $src"
done

[[ -d "$HOME/.ssh" ]] && chmod 700 "$HOME/.ssh"

# ~/.tmux.conf comes from oh-my-tmux, which is not vendored here.
if [[ ! -d "$HOME/.tmux" ]]; then
  echo "note: oh-my-tmux missing; install with:"
  echo "  git clone https://github.com/gpakosz/.tmux.git ~/.tmux && ln -s .tmux/.tmux.conf ~/.tmux.conf"
fi
if [[ ! -d "$HOME/.vim/plugged" ]]; then
  echo "note: run :PlugInstall in vim to install plugins"
fi
