#!/bin/bash
#############################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
#############################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

source $THISDIR/lib/bash_utils.sh

function usage {
  echo "Usage: install_dotfiles.sh [-f] [-s] [-e]"
  echo "  -f copy and install"
  echo "  -s soft linke install"
  echo "  -e install dependencies"
  echo "  -c cleanse install"
}

function install_local_bins {
  mkdir_nowarn $HOME/.local/bin
  cp $THISDIR/bin/* $HOME/.local/bin
}

# auto completion of SBCL with rlwrap
function handle_rlwrap {
  if [ ! -e $HOME/.sbcl_completions ] || [ -L $HOME/.sbcl_completions ]; then
    # Do not overwrite user local configs
    if [ x$SOFTLINK == "x1" ]; then
      ln -sf $THISDIR/rlwrap/sbcl_completions $HOME/.sbcl_completions
    else
      cp $THISDIR/rlwrap/sbcl_completions $HOME/.sbcl_completions
    fi
  else
    warn "$HOME/.sbcl_completions existed, skip without rewriting"
  fi
}

function handle_kitty {
  mkdir_nowarn $XDG_CONFIG_HOME/kitty
  if [ x$SOFTLINK == "x1" ]; then
    CMD="ln -sf"
  else
    CMD="cp -r"
  fi
  $CMD $THISDIR/kitty/kitty.conf $XDG_CONFIG_HOME/kitty/kitty.conf
}

function cleanse_kitty {
  rm -rf $XDG_CONFIG_HOME/kitty/kitty.conf
  info "kitty cleansed!"
}

function cleanse_all {
  for i in $(ls $THISDIR/bin/); do
    bname=$(basename $i)
    if [ -e $HOME/.local/bin/$bname ]; then
      rm -f $HOME/.local/bin/$bname
    fi
  done
  rm -rf $HOME/.sbcl_completions
  cleanse_kitty
  info "All cleansed!"
}

####################################################

# Change to 0 to install a copy instead of soft link
SOFTLINK=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) SOFTLINK=0 ;;
  s) SOFTLINK=1 ;;
  e) WITHDEPS=1 ;;
  c) cleanse_all && exit 0 ;;
  h | ?) usage && exit 0 ;;
  esac
done

install_local_bins
handle_rlwrap
handle_kitty

sh $THISDIR/emacs/install.sh $@
sh $THISDIR/zsh/install.sh $@
sh $THISDIR/nvim/install.sh $@
sh $THISDIR/tmux/install.sh $@

info "Installed successfully!"
