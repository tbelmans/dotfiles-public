# Shared steps for install-mac.sh and install-linux.sh. Sourced, not run.
# Expects $REPO to be set and git, zsh, vim, tmux and curl to be installed.

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# Clone $1 into $2 unless it already exists.
clone() {
  if [[ -d "$2/.git" ]]; then
    log "present    $2"
  else
    log "clone      $1 -> $2"
    git clone --depth 1 "$1" "$2"
  fi
}

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log "present    ~/.oh-my-zsh"
  else
    log "install    oh-my-zsh"
    # KEEP_ZSHRC: our .zshrc is linked by setup.sh; CHSH/RUNZSH: we handle those.
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
  clone https://github.com/zsh-users/zsh-autosuggestions "$custom/zsh-autosuggestions"
  clone https://github.com/zsh-users/zsh-syntax-highlighting "$custom/zsh-syntax-highlighting"
  clone https://github.com/sunlei/zsh-ssh "$custom/zsh-ssh"
}

install_oh_my_tmux() {
  clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
  if [[ ! -e "$HOME/.tmux.conf" ]]; then
    ln -s .tmux/.tmux.conf "$HOME/.tmux.conf"
    log "link       ~/.tmux.conf -> .tmux/.tmux.conf"
  fi
}

link_dotfiles() {
  log "link dotfiles"
  "$REPO/setup.sh"
}

# Git identity is per user: kept in ~/.gitconfig.local, which .gitconfig
# includes. Uses $GIT_USER_NAME / $GIT_USER_EMAIL if set, else asks.
setup_git_identity() {
  local file="$HOME/.gitconfig.local" name email
  name="$(git config -f "$file" user.name 2>/dev/null || true)"
  email="$(git config -f "$file" user.email 2>/dev/null || true)"
  name="${name:-${GIT_USER_NAME:-}}"
  email="${email:-${GIT_USER_EMAIL:-}}"
  if [[ -t 0 ]]; then
    [[ -n "$name" ]]  || read -rp "git user.name:  " name
    [[ -n "$email" ]] || read -rp "git user.email: " email
  fi
  [[ -n "$name" ]]  && git config -f "$file" user.name "$name"
  [[ -n "$email" ]] && git config -f "$file" user.email "$email"
  if [[ -n "$name" && -n "$email" ]]; then
    log "git        $name <$email> ($file)"
  else
    echo "warning: git identity not set; run:"
    echo "  git config -f ~/.gitconfig.local user.name  'Your Name'"
    echo "  git config -f ~/.gitconfig.local user.email 'you@example.com'"
  fi
}

# Clone the plugins listed in .vimrc ourselves: vim-plug can't be driven
# reliably without a terminal (in `vim -es` it quits before all clones
# finish). Same URL format and shallow depth as vim-plug, so it treats
# them as installed.
install_vim_plugins() {
  log "install    vim plugins"
  mkdir -p "$HOME/.config/vim/tmp/undo" "$HOME/.vim/plugged"
  local repo failed=()
  while read -r repo; do
    clone "https://git::@github.com/$repo.git" "$HOME/.vim/plugged/${repo#*/}" >/dev/null 2>&1 ||
      failed+=("$repo")
  done < <(sed -n "s#^Plug '\([^']*\)'.*#\1#p" "$HOME/.vimrc")
  # fzf's post-install hook: fetch the fzf binary.
  if [[ -x "$HOME/.vim/plugged/fzf/install" && ! -x "$HOME/.vim/plugged/fzf/bin/fzf" ]]; then
    "$HOME/.vim/plugged/fzf/install" --bin >/dev/null 2>&1 || failed+=("fzf binary")
  fi
  if (( ${#failed[@]} )); then
    echo "warning: vim plugins failed: ${failed[*]}; open vim and run :PlugInstall"
  fi
}

set_login_shell() {
  local zsh_path sudo=""
  # Prefer the path /etc/shells lists (e.g. /usr/bin/zsh, not /usr/sbin/zsh).
  zsh_path="$(grep -m1 '/zsh$' /etc/shells 2>/dev/null || true)"
  [[ -x "$zsh_path" ]] || zsh_path="$(command -v zsh)"
  if [[ "$(basename "${SHELL:-}")" == zsh ]]; then
    log "present    zsh is the login shell"
    return
  fi
  [[ $EUID -ne 0 ]] && sudo=sudo
  if ! grep -qxF "$zsh_path" /etc/shells; then
    echo "$zsh_path" | $sudo tee -a /etc/shells >/dev/null
  fi
  log "chsh       $zsh_path"
  # macOS: chsh asks for your password. Linux: the installer already needs
  # sudo, so use it and skip the PAM password prompt.
  if [[ "$(uname -s)" == Linux ]]; then
    $sudo chsh -s "$zsh_path" "$(id -un)"
  else
    chsh -s "$zsh_path"
  fi || echo "warning: chsh failed; run: chsh -s $zsh_path"
}

run_common() {
  install_oh_my_zsh
  install_oh_my_tmux
  link_dotfiles
  setup_git_identity
  install_vim_plugins
  set_login_shell
  log "done. Open a new terminal to start zsh."
}
