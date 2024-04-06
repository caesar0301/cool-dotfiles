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

source $THISDIR/../lib/bash_utils.sh

function install_pyenv {
    if [ ! -e $HOME/.pyenv ]; then
        info "Installing pyenv to $HOME/.pyenv..."
        git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
        git clone https://github.com/pyenv/pyenv-virtualenv.git $HOME/.pyenv/plugins/pyenv-virtualenv
    fi
}

function install_jenv {
    if [ ! -e $HOME/.jenv ]; then
        info "Installing jenv to $HOME/.jenv..."
        git clone https://github.com/jenv/jenv.git $HOME/.jenv
        ~/.jenv/bin/jenv enable-plugin export
    fi
}

function install_rbenv {
    if [ ! -e $HOME/.rbenv ]; then
        info "Installing rbenv to $HOME/.rbenv..."
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    fi
}

function install_zsh {
    info "Installing zsh..."
    mkdir_nowarn $HOME/.local/bin
    mkdir_nowarn /tmp/build-zsh
    curl -L --progress-bar http://ftp.funet.fi/pub/unix/shells/zsh/zsh-${ZSH_VERSION}.tar.xz | tar xJ -C /tmp/build-zsh/
    cd /tmp/build-zsh/zsh-${ZSH_VERSION} && ./configure --prefix $HOME/.local && make && make install && cd -
}

function install_java_decompiler {
    info "Installing CFR - another java decompiler"
    mkdir_nowarn $HOME/.local/bin
    target="$HOME/.local/bin/cfr-0.152.jar"
    if [ ! -e $target ]; then
        curl -L --progress-bar https://www.benf.org/other/cfr/cfr-0.152.jar --output $target
    fi
}

function install_all_deps {
    install_pyenv
    install_jenv
    install_java_decompiler
    install_rbenv
    if ! checkcmd zsh; then
        install_zsh
    fi
}

############################################################################

function handle_shell_proxy {
    if [ ! -e $HOME/.config/proxy ] || [ -L $HOME/.config/proxy ]; then
        if [ x$SOFTLINK == "x1" ]; then
            ln -sf $THISDIR/proxy-config $HOME/.config/proxy
        else
            cp $THISDIR/proxy-config $HOME/.config/proxy
        fi
    else
        warn "$HOME/.config/proxy existed, skip without rewriting"
    fi
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

    # Install bundled plugins
    mkdir_nowarn $XDG_CONFIG_HOME/zsh/plugins
    for i in $(find $THISDIR/plugins -name "*.plugin.zsh"); do
        dname=$(dirname $i)
        $CMD $dname $XDG_CONFIG_HOME/zsh/plugins/
    done
}

############################################################################

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

if [ "x$WITHDEPS" == "x1" ]; then
    install_all_deps
fi
handle_shell_proxy
handle_zsh
info "Zsh installed successfully!"
