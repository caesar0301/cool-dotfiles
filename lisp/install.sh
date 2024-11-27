#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

source $THISDIR/../lib/shmisc.sh

function usage {
  echo "Usage: install.sh [-f] [-s] [-e]"
  echo "  -f copy and install"
  echo "  -s soft linke install"
  echo "  -e install dependencies"
  echo "  -c cleanse install"
}

function install_deps {
  if ! checkcmd ros; then
    warn "roswell not installed, visit https://roswell.github.io/Installation.html"
  fi
}

function handle_lisp {
  if [ x$SOFTLINK == "x1" ]; then
    ln -sf $THISDIR/dot-clinit.cl $HOME/.clinit.cl
    ln -sf $THISDIR/dot-sbclrc $HOME/.sbclrc
  else
    cp $THISDIR/dot-clinit.cl $HOME
    cp $THISDIR/dot-sbclrc $HOME/.sbclrc
  fi
}

function cleanse_lisp {
  rm -rf $HOME/.clinit.cl
  rm -rf $HOME/.sbclrc
  info "All lisp cleansed!"
}

# Change to 0 to install a copy instead of soft link
SOFTLINK=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) SOFTLINK=0 ;;
  s) SOFTLINK=1 ;;
  e) WITHDEPS=1 ;;
  c) cleanse_lisp && exit 0 ;;
  h | ?) usage && exit 0 ;;
  esac
done

install_deps
handle_lisp
info "lisp installed successfully!"
