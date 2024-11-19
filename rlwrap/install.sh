#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
RLWRAP_HOME=${XDG_CONFIG_HOME}/rlwrap

source $THISDIR/../lib/bash_utils.sh

function usage {
  echo "Usage: install.sh [-f] [-s] [-e]"
  echo "  -f copy and install"
  echo "  -s soft linke install"
  echo "  -e install dependencies"
  echo "  -c cleanse install"
}

function handle_rlwrap {
  mkdir_nowarn $RLWRAP_HOME
  if [ x$SOFTLINK == "x1" ]; then
    ln -sf $THISDIR/lisp_completions $RLWRAP_HOME/lisp_completions
    ln -sf $THISDIR/sbcl_completions $RLWRAP_HOME/sbcl_completions
  else
    cp $THISDIR/lisp_completions $RLWRAP_HOME/
    cp $THISDIR/sbcl_completions $RLWRAP_HOME/
  fi
}

function cleanse_rlwrap {
  rm -rf $RLWRAP_HOME/lisp_completions
  rm -rf $RLWRAP_HOME/sbcl_completions
  info "All rlwrap cleansed!"
}

# Change to 0 to install a copy instead of soft link
SOFTLINK=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) SOFTLINK=0 ;;
  s) SOFTLINK=1 ;;
  e) WITHDEPS=1 ;;
  c) cleanse_rlwrap && exit 0 ;;
  h | ?) usage && exit 0 ;;
  esac
done

handle_rlwrap
info "rlwrap installed successfully!"
