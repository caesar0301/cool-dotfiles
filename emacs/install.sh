#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

source $THISDIR/../lib/bash_utils.sh

function usage {
    info "Usage: install.sh [-f] [-s] [-e]"
    info "  -f copy and install"
    info "  -s soft linke install"
    info "  -e install dependencies"
    info "  -c cleanse install"
}

function handle_emacs {
    mkdir_nowarn ~/.emacs.d
    rm -rf $HOME/.emacs.d/settings
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $THISDIR/emacs/.emacs.d/settings $HOME/.emacs.d/settings
        ln -sf $THISDIR/emacs/.emacs.d/init.el $HOME/.emacs.d/init.el
    else
        cp -r $THISDIR/emacs/.emacs.d/settings $HOME/.emacs.d/
        cp $THISDIR/emacs/.emacs.d/init.el $HOME/.emacs.d/
    fi
}

function cleanse_emacs {
    rm -rf $HOME/.emacs.d/settings
    rm -rf $HOME/.emacs.d/init.el
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

handle_emacs
info "Emacs installed successfully!"
