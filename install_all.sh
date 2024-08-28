#!/bin/bash
#############################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
#############################################
THISDIR=$(dirname $(realpath $0))
source $THISDIR/lib/bash_utils.sh

function usage {
  echo "Usage: install_dotfiles.sh [-f] [-s] [-e]"
  echo "  -f copy and install"
  echo "  -s soft linke install"
  echo "  -e install dependencies"
  echo "  -c cleanse install"
}

components=(tmux zsh nvim emacs misc)
for key in "${components[@]}"; do
  start_install_msg $key
  sh $THISDIR/$key/install.sh $@
  finish_install_msg $key
done
