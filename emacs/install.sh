#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
QUICKLISP_HOME=${HOME}/quicklisp

## Uncomment to respect XDG config. Here we use
## .emacs.d to be compatible with ACL emacs-lisp interface.
#EM_CONFIG=${XDG_CONFIG_HOME}/emacs
EM_CONFIG=${HOME}/.emacs.d
CLCMD="sbcl --load"

source $THISDIR/../lib/shmisc.sh

function usage {
  echo "Usage: install.sh [-f] [-s] [-e]"
  echo "  -f copy and install"
  echo "  -s soft linke install"
  echo "  -e install dependencies"
  echo "  -c cleanse install"
}

function detect_cl_cmd {
  # SBCL
  if checkcmd sbcl; then
    CLCMD="sbcl --load"
    return
  fi
  # Allegro CL
  if checkcmd alisp; then
    CLCMD="alisp -L"
    return
  fi
  error "any CL distribution not found"
  exit 1
}

function install_quicklisp {
  info "Install quicklisp..."
  if [ -e $QUICKLISP_HOME ]; then
    warn "quicklisp already installed at $QUICKLISP_HOME"
    return
  fi
  detect_cl_cmd
  curl -o /tmp/quicklisp.lisp https://beta.quicklisp.org/quicklisp.lisp
  $CLCMD "$THISDIR/install_quicklisp.lisp"
}

function handle_emacs {
  mkdir_nowarn $EM_CONFIG
  if [ x$SOFTLINK == "x1" ]; then
    ln -sf $THISDIR/base $EM_CONFIG/
    ln -sf $THISDIR/plugins $EM_CONFIG/
    ln -sf $THISDIR/init.el $EM_CONFIG/
  else
    cp -r $THISDIR/base $EM_CONFIG/
    cp -r $THISDIR/plugins $EM_CONFIG/
    cp $THISDIR/init.el $EM_CONFIG/
  fi
}

function cleanse_emacs {
  rm -rf $EM_CONFIG/base
  rm -rf $EM_CONFIG/plugins
  rm -rf $EM_CONFIG/init.el
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

install_quicklisp
handle_emacs
info "Emacs installed successfully!"
