#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

source $THISDIR/../lib/bash_utils.sh

function usage {
  echo "Usage: install.sh [-f] [-s] [-e]"
  echo "  -f copy and install"
  echo "  -s soft linke install"
  echo "  -e install dependencies"
  echo "  -c cleanse install"
}

function handle_emacs {
  mkdir_nowarn ~/.emacs.d
  cleanse_emacs
  if [ x$SOFTLINK == "x1" ]; then
    ln -sf $THISDIR/.emacs.d/base $HOME/.emacs.d/base
    ln -sf $THISDIR/.emacs.d/melpa $HOME/.emacs.d/melpa
    ln -sf $THISDIR/.emacs.d/plugins $HOME/.emacs.d/plugins
    ln -sf $THISDIR/.emacs.d/init.el $HOME/.emacs.d/init.el
  else
    cp -r $THISDIR/.emacs.d/base $HOME/.emacs.d/
    cp -r $THISDIR/.emacs.d/melpa $HOME/.emacs.d/
    cp -r $THISDIR/.emacs.d/plugins $HOME/.emacs.d/
    cp $THISDIR/.emacs.d/init.el $HOME/.emacs.d/
  fi
}

function cleanse_emacs {
  rm -rf $HOME/.emacs.d/base
  rm -rf $HOME/.emacs.d/melpa
  rm -rf $HOME/.emacs.d/plugins
  rm -rf $HOME/.emacs.d/init.el
  info "All emacs cleansed!"
}

# Change to 0 to install a copy instead of soft link
SOFTLINK=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) SOFTLINK=0 ;;
  s) SOFTLINK=1 ;;
  e) WITHDEPS=1 ;;
  c) cleanse_emacs && exit 0 ;;
  h | ?) usage && exit 0 ;;
  esac
done

handle_emacs
info "Emacs installed successfully!"
