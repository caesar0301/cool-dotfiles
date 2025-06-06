#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname "$(realpath "$0")")
XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
RLWRAP_HOME=${XDG_CONFIG_HOME}/rlwrap

source "$THISDIR/../lib/shmisc.sh"

# Function to handle file operations
handle_file() {
  local src=$1
  local dest=$2
  local cmd=$3
  if [ "$cmd" == "ln" ]; then
    ln -sf "$src" "$dest" || error "Failed to create soft link for $src"
  elif [ "$cmd" == "cp" ]; then
    cp -r "$src" "$dest" || error "Failed to copy $src"
  fi
}

# Function to handle rlwrap configuration
handle_rlwrap() {
  create_dir "$RLWRAP_HOME"
  install_file_pair "$THISDIR/lisp_completions" "$RLWRAP_HOME/lisp_completions"
  install_file_pair "$THISDIR/sbcl_completions" "$RLWRAP_HOME/sbcl_completions"
}

# Function to cleanse rlwrap configuration
cleanse_rlwrap() {
  rm -rf "$RLWRAP_HOME/lisp_completions"
  rm -rf "$RLWRAP_HOME/sbcl_completions"
  info "All rlwrap files cleansed!"
}

# Change to 0 to install a copy instead of soft link
LINK_INSTEAD_OF_COPY=1
while getopts fsch opt; do
  case $opt in
  f) LINK_INSTEAD_OF_COPY=0 ;;
  s) LINK_INSTEAD_OF_COPY=1 ;;
  c) cleanse_rlwrap && exit 0 ;;
  h | ?) usage_me "install.sh" && exit 0 ;;
  esac
done

handle_rlwrap

info "rlwrap installed successfully!"