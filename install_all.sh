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

components=(tmux zsh nvim vifm  emacs misc )
# components+=(lisp rlwrap)

for key in "${components[@]}"; do
  info "➜ START INSTALLING $key"
  sh $THISDIR/$key/install.sh $@
  if [ $? -eq 0 ]; then
    info "✔ FINISH INSTALLING $key"
  else
    error "✖ ERROR INSTALLING $key"
  fi
done

info "🎉 All installed successfully!"