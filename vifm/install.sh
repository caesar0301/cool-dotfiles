#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
VIFM_CONFIG_HOME=${XDG_CONFIG_HOME}/vifm

source $THISDIR/../lib/bash_utils.sh

function usage {
  echo "Usage: install.sh [-f] [-s] [-e]"
  echo "  -f copy and install"
  echo "  -s soft linke install"
  echo "  -e install dependencies"
  echo "  -c cleanse install"
}

function install_vifm {
  if ! checkcmd vifm; then
    warn "vifm binary not found, skip"
    exit 0
  fi
}

function handle_vifm {
  mkdir_nowarn $VIFM_CONFIG_HOME
  if [ x$SOFTLINK == "x1" ]; then
    ln -sf $THISDIR/vifmrc $VIFM_CONFIG_HOME/vifmrc
    ln -sf $THISDIR/scripts $VIFM_CONFIG_HOME/
    ln -sf $THISDIR/colors $VIFM_CONFIG_HOME/
  else
    cp $THISDIR/vifmrc $VIFM_CONFIG_HOME/vifmrc
    cp -r $THISDIR/scripts $VIFM_CONFIG_HOME/
    cp -r $THISDIR/colors $VIFM_CONFIG_HOME/
  fi
}

function cleanse_vifm {
  rm -rf $VIFM_CONFIG_HOME/vifmrc
  rm -rf $VIFM_CONFIG_HOME/scripts
  rm -rf $VIFM_CONFIG_HOME/colors
  info "All vifm cleansed!"
}

# Change to 0 to install a copy instead of soft link
SOFTLINK=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) SOFTLINK=0 ;;
  s) SOFTLINK=1 ;;
  e) WITHDEPS=1 ;;
  c) cleanse_vifm && exit 0 ;;
  h | ?) usage && exit 0 ;;
  esac
done

install_vifm
handle_vifm

info "vifm installed successfully!"
