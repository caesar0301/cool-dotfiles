# cool-dotfiles

Personal collection of dotfiles

## Install all dotfiles

Clone this repo

```bash
git clone --depth=1 https://github.com/caesar0301/cool-dotfiles.git ~/.dotfiles
```

Run `install_dotfiles.sh` automatically installs dependencies and configures `zsh`, `nvim`, `tmux` and `emacs` etc.

```bash
./install_dotfiles.sh     # Install dotfiles by soft links (default)
./install_dotfiles.sh -f  # Install dotfiles by copying
./install_dotfiles.sh -e  # With essential dependencies
./install_dotfiles.sh -c  # Cleanse installer changes
```

## Install specific module

### Nvim

Run `sh nvim/install.sh` and refer to [nvim/README.md](nvim/README.md)

### Zsh

Run `sh zsh/install.sh` and refer to [zsh/README.md](zsh/README.md)

### Tmux

Run `sh tmux/install.sh`

### Emacs

Run `sh emacs/install.sh`
