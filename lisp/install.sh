#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
QUICKLISP_HOME=${QUICKLISP_HOME:-${HOME}/quicklisp}
ACL_HOME=${XDG_DATA_HOME}/acl

source $THISDIR/../lib/shmisc.sh

function usage {
  echo "Usage: install.sh [-f] [-s] [-e]"
  echo "  -f copy and install"
  echo "  -s soft linke install"
  echo "  -e install dependencies"
  echo "  -c cleanse install"
}

function install_quicklisp {
  info "Installing quicklisp..."
  if ! checkcmd sbcl; then
    warn "sbcl not found, install and retry"
    return 1
  fi
  if [ -e ${QUICKLISP_HOME}/setup.lisp ]; then
    warn "quicklisp alreay installed at ${QUICKLISP_HOME}"
  else
    curl -s https://beta.quicklisp.org/quicklisp.lisp -o /tmp/quicklisp.lisp
    sbcl --load /tmp/quicklisp.lisp --eval '(quicklisp-quickstart:install)' --quit
    rm -rf /tmp/quicklisp.lisp
  fi
}

function install_useful_libs {
  info "Installing lisp libraries via quicklisp..."
  libs=(quicksys alexandria)
  sbcl --eval "(ql:quickload '(\"quicklisp-slime-helper\" \"alexandria\"))" --quit
}

function install_allegro_cl {
  info "(Optional) Installing Allegro CL Express Edition..."

  local DLINK
  if is_linux; then
    if is_x86_64; then
      DLINK="https://franz.com/ftp/pub/acl11.0express/linuxamd64.64/acl11.0express-linux-x64.tbz2"
    else # aarch64
      DLINK="https://franz.com/ftp/pub/acl11.0express/linuxarm64.64/acl11.0express-linux-aarch64v8.tbz2"
    fi
  elif is_macos; then
    error "Allegro CL should be installed maually on MacOS:"
    error "1. download from https://franz.com/downloads/clp/download"
    error "2. mount the dmg and install files:"
    error "  cp -r /Volumes/AllegroCL64express/AllegroCL64express.app/Contents/Resources/* ~/.local/share/acl/"
    error "3. build modern mode: ~/.local/share/acl/alisp -L build_modern_mode_allegro.lisp"
    return 1
  else
    error "Unsupported OS" && return 1
  fi

  local TARNAME=$(basename $DLINK)
  if [ -e $ACL_HOME/alisp ]; then
    warn "ACL already installed at ${ACL_HOME}/alisp"
  else
    if [ ! -e /tmp/$TARNAME ]; then
      curl $DLINK -o /tmp/$TARNAME
    fi
    create_dir $ACL_HOME
    tar --strip-components=1 -xjf /tmp/$TARNAME -C $ACL_HOME
  fi

  warn "You should add ${ACL_HOME} to your PATH for convinience"

  # ACL modern mode
  if [ -e $ACL_HOME/mlisp ]; then
    warn "ACL modern mode executable (mlisp) already exists"
  else
    info "Compiling ACL modern mode executable (mlisp)..."
    $ACL_HOME/alisp <<EOF
;; mlisp:
(progn
  (build-lisp-image "sys:mlisp.dxl" :case-mode :case-sensitive-lower
                    :include-ide nil :restart-app-function nil)
  (when (probe-file "sys:mlisp") (delete-file "sys:mlisp"))
  (sys:copy-file "sys:alisp" "sys:mlisp"))
EOF
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

install_quicklisp
install_useful_libs
install_allegro_cl
handle_lisp
info "lisp installed successfully!"
