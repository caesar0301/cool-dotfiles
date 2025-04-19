# cool-dotfiles

Personal collection of dotfiles.

[![Build and Push DevContainer Docker Image](https://github.com/caesar0301/cool-dotfiles/actions/workflows/build-devcontainer.yml/badge.svg)](https://github.com/caesar0301/cool-dotfiles/actions/workflows/build-devcontainer.yml)

## Install all dotfiles

Clone this repo

```bash
git clone --depth=1 https://github.com/caesar0301/cool-dotfiles.git ~/.dotfiles
```

Run `install_all.sh` automatically installs dependencies and configures `zsh`, `nvim`, `tmux` and `emacs` etc.

```bash
./install_all.sh     # Install dotfiles by soft links (default)
./install_all.sh -f  # Install dotfiles by copying
./install_all.sh -e  # With essential dependencies
./install_all.sh -c  # Cleanse installer changes
```

## Install specific module

### Nvim

Run `sh nvim/install.sh` and refer to [nvim/README.md](nvim/README.md)

### Zsh

Run `sh zsh/install.sh` and refer to [zsh/README.md](zsh/README.md)

Plugins:

* [caesardev](https://github.com/caesar0301/zsh-plugin-caesardev): my personal daily dev plugins

### Tmux

Run `sh tmux/install.sh`

### Emacs

Run `sh emacs/install.sh`
