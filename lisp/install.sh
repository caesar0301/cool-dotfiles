#!/bin/bash
###################################################
# Install script for Common Lisp development environment
# https://github.com/caesar0301/cool-dotfiles
#
# Features:
# - Quicklisp package manager
# - Allegro CL Express Edition
# - Common utilities and libraries
#
# Maintainer: xiaming.chen
###################################################

set -euo pipefail

# Resolve script location
THISDIR=$(dirname "$(realpath "$0")")

# Load common utilities
source "$THISDIR/../lib/shmisc.sh" || {
  echo "Error: Failed to load shmisc.sh"
  exit 1
}

readonly QUICKLISP_HOME="$HOME/quicklisp"
readonly ACL_HOME="$XDG_DATA_HOME/acl"

# Default configuration
readonly DEFAULT_LISP_LIBS=("quicklisp-slime-helper" "alexandria")

function usage {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -f    Copy and install files
  -s    Create symbolic links instead of copying
  -e    Install dependencies
  -c    Clean installation
  -h    Show this help message
EOF
}

function install_quicklisp {
  info "Installing Quicklisp package manager..."

  if ! checkcmd sbcl; then
    error "Steel Bank Common Lisp (sbcl) not found. Please install it first."
    return 1
  fi

  if [ -e "$QUICKLISP_HOME/setup.lisp" ]; then
    warn "Quicklisp already installed at $QUICKLISP_HOME"
    return 0
  fi

  local QUICKLISP_SETUP="/tmp/quicklisp.lisp"
  if ! curl -fsSL https://beta.quicklisp.org/quicklisp.lisp -o "$QUICKLISP_SETUP"; then
    error "Failed to download Quicklisp setup file"
    return 1
  fi

  if ! sbcl --load "$QUICKLISP_SETUP" \
          --eval '(quicklisp-quickstart:install)' \
          --quit; then
    error "Failed to install Quicklisp"
    rm -f "$QUICKLISP_SETUP"
    return 1
  fi

  rm -f "$QUICKLISP_SETUP"
  info "Quicklisp installation completed"
}

function install_useful_libs {
  info "Installing Common Lisp libraries..."

  if ! [ -e "$QUICKLISP_HOME/setup.lisp" ]; then
    error "Quicklisp not installed. Run install_quicklisp first."
    return 1
  fi

  local LOAD_CMD="(ql:quickload '(${DEFAULT_LISP_LIBS[*]}))"
  if ! sbcl --eval "$LOAD_CMD" --quit; then
    error "Failed to install libraries"
    return 1
  fi

  info "Libraries installation completed"
}

function install_allegro_cl {
  # Check if already installed
  if [ -e "$ACL_HOME/alisp" ]; then
    warn "Allegro CL already installed at $ACL_HOME/alisp"
    return 0
  fi

  create_dir "$ACL_HOME"

  # Install based on OS
  if is_linux; then
    local DLINK
    if is_x86_64; then
      DLINK="https://franz.com/ftp/pub/acl11.0express/linuxamd64.64/acl11.0express-linux-x64.tbz2"
    elif is_arm64; then
      DLINK="https://franz.com/ftp/pub/acl11.0express/linuxarm64.64/acl11.0express-linux-aarch64v8.tbz2"
    else
      error "Unsupported Linux architecture"
      return 1
    fi

    # Download and extract
    local TARNAME=$(basename "$DLINK")
    if [ ! -e "/tmp/$TARNAME" ]; then
      info "Downloading Allegro CL..."
      curl -L "$DLINK" -o "/tmp/$TARNAME"
    fi
    info "Extracting Allegro CL..."
    tar --strip-components=1 -xjf "/tmp/$TARNAME" -C "$ACL_HOME"

  elif is_macos; then
    info "Please download Allegro CL from: https://franz.com/downloads/clp/download"
    info "After downloading, please mount the DMG file"

    while [ ! -d "/Volumes/AllegroCL64express" ]; do
      info "Waiting for AllegroCL64express volume to be mounted..."
      sleep 2
    done

    info "Copying Allegro CL files..."
    cp -r "/Volumes/AllegroCL64express/AllegroCL64express.app/Contents/Resources/"* "$ACL_HOME"
  else
    error "Unsupported operating system"
    return 1
  fi

  # Build modern mode
  if [ ! -e "$ACL_HOME/mlisp" ]; then
    info "Compiling modern mode executable (mlisp)..."
    if ! "$ACL_HOME/alisp" -L "$THISDIR/build_modern_mode_allegro.lisp" -e '(exit 0)' -kill; then
      error "Failed to compile modern mode"
      return 1
    fi
  fi

  info "Allegro CL installation completed"
  warn "You should add ${ACL_HOME} to your PATH for convenience"
  return 0
}

function handle_lisp {
  install_file_pairs "$THISDIR/dot-clinit.cl" "$HOME/.clinit.cl" \
    "$THISDIR/dot-sbclrc" "$HOME/.sbclrc"
}

function cleanse_lisp {
  rm -rf $HOME/.clinit.cl
  rm -rf $HOME/.sbclrc
  info "All lisp cleansed!"
}

# Change to 0 to install a copy instead of soft link
LINK_INSTEAD_OF_COPY=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) LINK_INSTEAD_OF_COPY=0 ;;
  s) LINK_INSTEAD_OF_COPY=1 ;;
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
