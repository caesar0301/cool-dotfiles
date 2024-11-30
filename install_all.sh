#!/bin/bash
#############################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
#############################################
THISDIR=$(dirname $(realpath $0))
source $THISDIR/lib/shmisc.sh

function usage {
  echo "Usage: install_dotfiles.sh [-f] [-s] [-e]"
  echo "  -f copy and install"
  echo "  -s soft linke install"
  echo "  -e install dependencies"
  echo "  -c cleanse install"
}

function start_install_msg {
  info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  info "START INSTALLING $1"
}

function finish_install_msg {
  info "FINISH INSTALLING $1"
  info "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
}

components=(tmux zsh nvim vifm lisp emacs rlwrap misc)
for key in "${components[@]}"; do
  start_install_msg $key
  sh $THISDIR/$key/install.sh $@
  finish_install_msg $key
done
