#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname "$(realpath "$0")")
XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}

## Uncomment to respect XDG config. Here we use
## .emacs.d to be compatible with ACL emacs-lisp interface.
EM_CONFIG=${XDG_CONFIG_HOME}/emacs
QUICKLISP_HOME=${QUICKLISP_HOME:-${HOME}/quicklisp}

source "$THISDIR/../lib/shmisc.sh"

INSTALL_FILES=(
  lisp
  plugins
  init.el
)

# Function to display usage information
usage() {
  info "Usage: install.sh [-f] [-s] [-e] [-c]"
  info "  -f copy and install"
  info "  -s soft link install"
  info "  -e install dependencies"
  info "  -c cleanse install"
}

# Function to check SLIME dependencies
check_slime_deps() {
  if [ ! -e "${QUICKLISP_HOME}/slime-helper.el" ]; then
    warn "quicklisp-slime-helper not found"
  fi
}

# Function to check Emacs dependencies
check_emacs_deps() {
  if ! checkcmd aspell; then
    warn "aspell not found to enable spell check"
  fi
}

# Function to handle Emacs configuration
handle_emacs() {
  create_dir "$EM_CONFIG"
  for file in "${INSTALL_FILES[@]}"; do
    install_file_pair "$THISDIR/$file" "$EM_CONFIG/$file"
  done
}

# Function to cleanse Emacs configuration
cleanse_emacs() {
  for file in "${INSTALL_FILES[@]}"; do
    rm -f "$EM_CONFIG/$file"
  done
  info "All Emacs files cleansed!"
}

# Change to 0 to install a copy instead of soft link
LINK_INSTEAD_OF_COPY=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) LINK_INSTEAD_OF_COPY=0 ;;
  s) LINK_INSTEAD_OF_COPY=1 ;;
  e) WITHDEPS=1 ;;
  c) cleanse_emacs && exit 0 ;;
  h | ?) usage && exit 0 ;;
  esac
done

if [ "$WITHDEPS" == "1" ]; then
  check_slime_deps
  check_emacs_deps
fi

handle_emacs
info "Emacs installed successfully!"