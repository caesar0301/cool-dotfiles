#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

ZSH_VERSION="5.8"

source $THISDIR/../lib/shmisc.sh

function install_zinit {
  local ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
  [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
  [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
}

function handle_zsh {
  mkdir_nowarn $XDG_CONFIG_HOME/zsh

  if [ ! -e $HOME/.zshrc ] || [ -L $HOME/.zshrc ]; then
    # Do not overwrite user local configs
    cp $THISDIR/zshrc $HOME/.zshrc
  else
    warn "$HOME/.zsrhc existed, skip without rewriting"
  fi

  if [ x$SOFTLINK == "x1" ]; then
    CMD="ln -sf"
  else
    CMD="cp -r"
  fi
  $CMD $THISDIR/init.zsh $XDG_CONFIG_HOME/zsh/init.zsh
  $CMD $THISDIR/bundles $XDG_CONFIG_HOME/zsh/

  # Install extra plugins
  mkdir_nowarn $XDG_CONFIG_HOME/zsh/plugins
  for i in $(find $THISDIR/plugins -name "*.plugin.zsh"); do
    dname=$(dirname $i)
    $CMD $dname $XDG_CONFIG_HOME/zsh/plugins/
  done
}

function cleanse_zsh {
  rm -rf $XDG_CONFIG_HOME/zsh/init.zsh
  ZSHPLUG=$THISDIR/plugins
  if [ -e $ZSHPLUG ]; then
    for i in $(find $ZSHPLUG -name "*.plugin.zsh"); do
      dname=$(dirname $i)
      rm -rf $XDG_CONFIG_HOME/zsh/plugins/$(basename $dname)
    done
  fi
  rm -rf $XDG_DATA_HOME/zinit
  info "All zsh cleansed!"
}

function usage {
  info "Usage: install.sh [-f] [-s] [-e]"
  info "  -f copy and install"
  info "  -s soft linke install"
  info "  -e install dependencies"
  info "  -c cleanse install"
}

# Change to 0 to install a copy instead of soft link
SOFTLINK=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) SOFTLINK=0 ;;
  s) SOFTLINK=1 ;;
  e) WITHDEPS=1 ;;
  c) cleanse_zsh && exit 0 ;;
  h | ?) usage && exit 0 ;;
  esac
done

install_zsh
install_zinit
if [ "x$WITHDEPS" == "x1" ]; then
  install_pyenv
  install_jenv
  install_java_decompiler
fi
handle_zsh
info "Zsh installed successfully!"
