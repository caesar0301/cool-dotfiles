# cool-dotfiles

Personal collection of dotfiles

## Usage

The script `install_dotfiles.sh` automatically installs dependencies and configures `zsh`, `nvim`, `tmux` and `emacs` etc.

```bash
# Install dotfiles by soft links (default)
./install_dotfiles.sh

# Install dotfiles by copying
./install_dotfiles.sh -f

# With essential dependencies
./install_dotfiles.sh -e

# Cleanse installer changes
./install_dotfiles.sh -c
```
