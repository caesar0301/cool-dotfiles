#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname "$(realpath "$0")")
XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
VIFM_CONFIG_HOME=${XDG_CONFIG_HOME}/vifm

source "$THISDIR/../lib/shmisc.sh"

INSTALL_FILES=(
  vifmrc
  scripts
  colors
)

# Function to display usage information
usage() {
  info "Usage: install.sh [-f] [-s] [-e] [-c]"
  info "  -f copy and install"
  info "  -s soft link install"
  info "  -e install dependencies"
  info "  -c cleanse install"
}

# Function to install Vifm
install_vifm() {
  if ! checkcmd vifm; then
    warn "vifm binary not found, skip"
    exit 0
  fi
}

# Function to handle Vifm configuration
handle_vifm() {
  create_dir "$VIFM_CONFIG_HOME"
  for i in "${INSTALL_FILES[@]}"; do
    install_file_pair "$THISDIR/$i" "$VIFM_CONFIG_HOME/$i"
  done
}

# Function to cleanse Vifm configuration
cleanse_vifm() {
  for i in "${INSTALL_FILES[@]}"; do
    rm -rf "$VIFM_CONFIG_HOME/$i"
  done
  info "All Vifm files cleansed!"
}

# Change to 0 to install a copy instead of soft link
LINK_INSTEAD_OF_COPY=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) LINK_INSTEAD_OF_COPY=0 ;;
  s) LINK_INSTEAD_OF_COPY=1 ;;
  e) WITHDEPS=1 ;;
  c) cleanse_vifm && exit 0 ;;
  h | ?) usage && exit 0 ;;
  esac
done

install_vifm
handle_vifm

info "Vifm installed successfully!"