#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname "$(realpath "$0")")
XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}

ZSH_VERSION="5.8"

# Load common utils
source "$THISDIR/../lib/shmisc.sh"

INSTALL_FILES=(
  init.zsh
  _helper.zsh
)

# Function to install Zinit
install_zinit() {
  local ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"
  create_dir "$(dirname "$ZINIT_HOME")"
  if [ ! -d "$ZINIT_HOME/.git" ]; then
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" || error "Failed to clone Zinit"
  fi
}

handle_shell_proxy() {
  if [ ! -e $HOME/.config/proxy ] || [ -L $HOME/.config/proxy ]; then
    install_file_pairs "$THISDIR/config/proxy-config" "$HOME/.config/proxy"
  else
    warn "$HOME/.config/proxy existed, skip without rewriting"
  fi
}

# Function to handle Zsh configuration
handle_zsh() {
  create_dir "$XDG_CONFIG_HOME/zsh"

  if [ ! -e "$HOME/.zshrc" ] || [ -L "$HOME/.zshrc" ]; then
    install_file_pairs "$THISDIR/zshrc" "$HOME/.zshrc"
  else
    warn "$HOME/.zshrc existed, skip without rewriting"
  fi

  for i in "${INSTALL_FILES[@]}"; do
    install_file_pairs "$THISDIR/$i" "$XDG_CONFIG_HOME/zsh/$i"
  done

  # Install extra plugins
  create_dir "$XDG_CONFIG_HOME/zsh/plugins"
  for i in $(find "$THISDIR/plugins" -name "*.plugin.zsh"); do
    local dname
    dname=$(dirname "$i")
    install_file_pairs "$dname" "$XDG_CONFIG_HOME/zsh/plugins/"
  done
}

# Function to cleanse Zsh configuration
cleanse_zsh() {
  rm -rf "$XDG_DATA_HOME/zinit"
  rm -rf "$HOME/.config/proxy"

  for i in "${INSTALL_FILES[@]}"; do
    rm -rf "$XDG_CONFIG_HOME/zsh/$i"
  done

  local ZSHPLUG="$THISDIR/plugins"
  if [ -e "$ZSHPLUG" ]; then
    for i in $(find "$ZSHPLUG" -name "*.plugin.zsh"); do
      local dname
      dname=$(dirname "$i")
      rm -rf "$XDG_CONFIG_HOME/zsh/plugins/$(basename "$dname")"
    done
  fi

  info "All Zsh files cleansed!"
}

# Function to display usage information
usage() {
  info "Usage: install.sh [-f] [-s] [-e] [-c]"
  info "  -f copy and install"
  info "  -s soft link install"
  info "  -e install dependencies"
  info "  -c cleanse install"
}

# Change to 0 to install a copy instead of soft link
LINK_INSTEAD_OF_COPY=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) LINK_INSTEAD_OF_COPY=0 ;;
  s) LINK_INSTEAD_OF_COPY=1 ;;
  e) WITHDEPS=1 ;;
  c) cleanse_zsh && exit 0 ;;
  h | ?) usage && exit 0 ;;
  esac
done

install_zsh
install_zinit
if [ "x$WITHDEPS" == "x1" ]; then
  install_pyenv
  install_jenv
  install_gvm
  install_java_decompiler
fi
handle_shell_proxy
handle_zsh
info "Zsh installed successfully!"
