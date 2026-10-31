# dotfiles

zsh (oh-my-zsh), vim (vim-plug), tmux (oh-my-tmux), git and Ghostty config
for macOS and Linux.

## Install

```sh
git clone https://github.com/tbelmans/dotfiles-public.git ~/dotfiles
~/dotfiles/install-external.sh
```

No git yet? Download the repo as a zip from GitHub, unpack it somewhere
permanent and run `install-external.sh` from there.

Keep the folder: your dotfiles are symlinks into it. Files they replace
are kept as `<file>.bak.<timestamp>`. The installer is safe to re-run.

### Git identity

The installer asks for your git name and email and stores them in
`~/.gitconfig.local`, outside the repo. To skip the prompt:

```sh
GIT_USER_NAME="Jane Doe" GIT_USER_EMAIL=jane@example.com ~/dotfiles/install-external.sh
```

### What it installs

- **macOS** (needs an admin account): Xcode Command Line Tools, Homebrew,
  git, zsh, vim, tmux, curl, ripgrep, Ghostty and the JetBrains Mono Nerd
  Font. On a fresh Mac the first run stops so you can install the Command
  Line Tools; run it again when that's done.
- **Linux** (apt, dnf, pacman, zypper or apk; needs sudo): git, zsh, vim,
  tmux, curl, cpio, ripgrep. Ghostty is not installed, but its config is
  linked to `~/.config/ghostty/config`.

Then it sets up oh-my-zsh with its plugins, oh-my-tmux and the vim
plugins, and makes zsh your login shell. `~/.ssh` is left alone.

### Your own additions

Put personal aliases and settings in `~/.zshrc.local`, and extra git
settings in `~/.gitconfig.local`. Both are loaded automatically and stay
out of the repo.
