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
    echo "Usage: install.sh [-f] [-s] [-e]"
    echo "  -f copy and install"
    echo "  -s soft linke install"
    echo "  -e install dependencies"
    echo "  -c cleanse install"
}

function handle_tmux {
    mkdir_nowarn $XDG_CONFIG_HOME/tmux
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $THISDIR/tmux/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
        ln -sf $THISDIR/tmux/tmux.conf.local $XDG_CONFIG_HOME/tmux/tmux.conf.local
    else
        cp $THISDIR/tmux/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
        cp $THISDIR/tmux/tmux.conf.local $XDG_CONFIG_HOME/tmux/tmux.conf.local
    fi
}

function cleanse_tmux {
    rm -rf $XDG_CONFIG_HOME/tmux/tmux.conf.local
    rm -rf $XDG_CONFIG_HOME/tmux/tmux.conf
    info "All tmux cleansed!"
}

# Change to 0 to install a copy instead of soft link
SOFTLINK=1
WITHDEPS=1
while getopts fsech opt; do
    case $opt in
    f) SOFTLINK=0 ;;
    s) SOFTLINK=1 ;;
    e) WITHDEPS=1 ;;
    c) cleanse_tmux && exit 0 ;;
    h | ?) usage && exit 0 ;;
    esac
done

handle_tmux

info "Tmux installed successfully!"
