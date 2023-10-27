#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

source $THISDIR/lib/bash_utils.sh

function usage {
    info "Usage: install_dotfiles.sh [-f] [-s] [-e]"
    info "  -f copy and install"
    info "  -s soft linke install"
    info "  -e install dependencies"
    info "  -c cleanse install"
}

function install_local_bins {
    mkdir_nowarn $HOME/.local/bin
    cp $THISDIR/local_bin/* $HOME/.local/bin
}

function install_ossutil {
    VERSION="1.7.17"
    OSSTR="linux"
    if [ "$(uname)" == "Darwin" ]; then
        OSSTR="mac"
    fi
    ARCHSTR="amd64"
    if [ "$(uname -m)" == "aarch64" ] || [ "$(uname -m)" == "arm64" ]; then
        ARCHSTR="arm64"
    fi
    FILENAME="ossutil-v${VERSION}-${OSSTR}-${ARCHSTR}.zip"
    DLINK="https://github.com/aliyun/ossutil/releases/download/v.$VERSION/$FILENAME"
    if [ ! -e $HOME/.local/bin/ossutil ]; then
        info "Downloading ossutil $FILENAME..."
        curl -L --progress-bar $DLINK -o /tmp/$FILENAME
        unzip -o -j /tmp/$FILENAME '*/ossutil' -d $HOME/.local/bin
    fi
}

function handle_ctags {
    if [ ! -e $HOME/.ctags ] || [ -L $HOME/.ctags ]; then
        # Do not overwrite user local configs
        if [ x$SOFTLINK == "x1" ]; then
            ln -sf $THISDIR/ctags/ctags $HOME/.ctags
        else
            cp $THISDIR/ctags/ctags $HOME/.ctags
        fi
    else
        warn "$HOME/.ctags existed, skip without rewriting"
    fi
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

function cleanse_all {
    for i in $(ls $THISDIR/local_bin/); do
        bname=$(basename $i)
        if [ -e $HOME/.local/bin/$bname ]; then
            rm -f $HOME/.local/bin/$bname
        fi
    done
    rm -rf $HOME/.ctags
    rm -rf $HOME/.sbcl_completions
    info "All cleansed!"
}

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
install_ossutil

handle_ctags
handle_rlwrap

sh $THISDIR/emacs/install.sh $@
sh $THISDIR/zsh/install.sh $@
sh $THISDIR/nvim/install.sh $@
sh $THISDIR/tmux/install.sh $@

info "Installed successfully!"
