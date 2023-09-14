#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

function warn {
    warn_prefix="\033[33m"
    mssg_suffix="\033[00m"
    echo -e "$warn_prefix"[$(date '+%Y-%m-%dT%H:%M:%S')] "$@""$mssg_suffix"
}
function info {
    info_prefix="\033[32m"
    mssg_suffix="\033[00m"
    echo -e "$info_prefix"[$(date '+%Y-%m-%dT%H:%M:%S')] "$@""$mssg_suffix"
}
function error {
    erro_prefix="\033[31m"
    mssg_suffix="\033[00m"
    echo -e "$erro_prefix"[$(date '+%Y-%m-%dT%H:%M:%S')] "$@""$mssg_suffix"
}

function usage {
    info "Usage: install_dotfiles.sh [-f] [-s] [-e]"
    info "  -f copy and install"
    info "  -s soft linke install"
    info "  -e install dependencies"
    info "  -c cleanse install"
}

function mkdir2 {
    if [ ! -e $1 ]; then mkdir -p $1; fi
}

function check_sudo_access {
    prompt=$(sudo -nv 2>&1)
    if [ $? -eq 0 ]; then
        info "has_sudo__pass_set"
    elif echo $prompt | grep -q '^sudo:'; then
        warn "has_sudo__needs_pass"
        sudo -v
    else
        error "no_sudo" && exit 1
    fi
}

############################################################################

function install_local_bins {
    cp $THISDIR/local_bin/* $HOME/.local/bin
}

function install_pyenv {
    if [ ! -e $HOME/.pyenv ]; then
        info "Installing pyenv to $HOME/.pyenv..."
        git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
        git clone https://github.com/pyenv/pyenv-virtualenv.git $HOME/.pyenv/plugins/pyenv-virtualenv
    fi
}

function install_fzf {
    if [ ! -e $HOME/.fzf ]; then
        info "Installing fzf to $HOME/.fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
        $HOME/.fzf/install
    fi
}

# Required by nvim-jdtls
function install_jdt_language_server {
    jdtlink="https://download.eclipse.org/jdtls/milestones/1.23.0/jdt-language-server-1.23.0-202304271346.tar.gz"
    dpath=$HOME/.local/share/jdt-language-server
    if [ ! -e $dpath/bin/jdtls ]; then
        info "Installing jdt-language-server to $dpath..."
        mkdir2 $dpath >/dev/null
        curl -L -s $jdtlink | tar zxf - -C $dpath
    fi
}

function install_hack_nerd_font {
    FONTDIR=$HOME/.local/share/fonts
    if [ "$(uname)" == "Darwin" ]; then
        FONTDIR=$HOME/Library/Fonts
    fi
    # install nerd patched font Hack, required by nvim-web-devicons
    if ! $(fc-list | grep "Hack Nerd Font" >/dev/null); then
        info "Install Hack nerd font and update font cache..."
        mkdir2 $FONTDIR
        curl -L -s https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.tar.xz | tar xJ - -C $FONTDIR
        fc-cache -f
    fi
}

function install_google_java_format {
    rfile="https://github.com/google/google-java-format/releases/download/v1.17.0/google-java-format-1.17.0-all-deps.jar"
    dpath=$HOME/.local/share/google-java-format
    if ! compgen -G "$dpath/google-java-format*.jar" >/dev/null; then
        info "Installing google-java-format to $dpath..."
        curl -L --progress-bar --create-dirs $rfile -o $dpath/google-java-format-all-deps.jar
    fi
}

function install_shfmt {
    info "Installing shfmt..."
    curl -sS https://webi.sh/shfmt | sh
}

#
# Python: black
# JS/JSON/HTTP/CSS: js-beautify
# Ruby: ruby-beautify
# Golang: gofmt
# Rust: rustfmt
# Perl: Perl::Tidy
# Haskell: stylish-haskell
# Markdown: remark-cli
# Shell: shfmt
# Lua: lua-fmt
# SQL: sqlformat
# CMake: cmake_format
# LaTeX: latexindent
# OCaml: ocamlformat
# LISP/Scheme: scmindent
#
function install_autoformat_deps {
    info "Installing vim-autoformat dependencies..."

    info "Installing deps from pip..."
    pip install -U black sqlformat cmake_format

    info "Installing deps from npm..."
    sudo npm install --quiet -g remark-cli js-beautify lua-fmt scmindent yaml-language-server

    info "Installing deps from gem..."
    sudo gem install --quiet ruby-beautify

    install_google_java_format
    install_shfmt

    # Install perl first
    # cpan -i Perl::Tidy
}

function install_zsh_deps {
    install_pyenv
}

function install_vim_deps {
    install_fzf
    install_jdt_language_server
    install_autoformat_deps
}

function install_neovim_deps {
    install_fzf
    install_jdt_language_server
    install_hack_nerd_font #Required by nvim-web-devicons
    install_autoformat_deps
}

############################################################################

function handle_zsh {
    # Install ZI
    if [ ! -e $HOME/.zi ]; then
        mkdir2 "$HOME/.zi/bin"
        mkdir2 "$HOME/.zi/completions"
        git clone https://github.com/z-shell/zi.git "$HOME/.zi/bin"
    fi
    mkdir2 $XDG_CONFIG_HOME/zsh

    if [ ! -e $HOME/.zshrc ]; then
        # Do not overwrite user local configs
        cp $THISDIR/zsh/zshrc $HOME/.zshrc
    else
        warn "$HOME/.zsrhc existed. Skip without rewriting"
    fi

    if [ x$SOFTLINK == "x1" ]; then
        CMD="ln -sf"
    else
        CMD="cp -r"
    fi
    $CMD $THISDIR/zsh/init.zsh $XDG_CONFIG_HOME/zsh/init.zsh

    # Install bundled plugins
    mkdir2 $XDG_CONFIG_HOME/zsh/plugins
    for i in $(find $THISDIR/zsh/plugins -name "*.plugin.zsh"); do
        dname=$(dirname $i)
        $CMD $dname $XDG_CONFIG_HOME/zsh/plugins/
    done
}

function handle_vim {
    # install vim-plug manager
    curl --progress-bar -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $THISDIR/vim/vimrc $HOME/.vimrc
    else
        cp $THISDIR/vim/vimrc $HOME/.vimrc
    fi
}

function handle_neovim {
    # install plugin manager
    packer_home=$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
    if [ ! -e ${packer_home} ]; then
        info "Install plugin manager Packer..."
        git clone --depth 1 https://github.com/wbthomason/packer.nvim \
            ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $THISDIR/nvim $XDG_CONFIG_HOME/
    else
        cp -r $THISDIR/nvim $XDG_CONFIG_HOME/
    fi
}

function handle_tmux {
    mkdir2 $XDG_CONFIG_HOME/tmux
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $THISDIR/tmux/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
        ln -sf $THISDIR/tmux/tmux.conf.local $XDG_CONFIG_HOME/tmux/tmux.conf.local
    else
        cp $THISDIR/tmux/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
        cp $THISDIR/tmux/tmux.conf.local $XDG_CONFIG_HOME/tmux/tmux.conf.local
    fi
}

function handle_emacs {
    mkdir2 mkdir ~/.emacs.d
    rm -rf $HOME/.emacs.d/settings
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $THISDIR/emacs/.emacs.d/settings $HOME/.emacs.d/settings
        ln -sf $THISDIR/emacs/.emacs.d/init.el $HOME/.emacs.d/init.el
    else
        cp -r $THISDIR/emacs/.emacs.d/settings $HOME/.emacs.d/
        cp $THISDIR/emacs/.emacs.d/init.el $HOME/.emacs.d/
    fi
}

############################################################################

function cleanse_all {
    for i in $(ls $THISDIR/local_bin/); do
        bname=$(basename $i)
        if [ -e $HOME/.local/bin/$bname ]; then
            rm -f $HOME/.local/bin/$bname
        fi
    done
    rm -rf $HOME/.emacs.d/settings
    rm -rf $HOME/.emacs.d/init.el
    rm -rf $XDG_CONFIG_HOME/tmux/tmux.conf.local
    rm -rf $XDG_CONFIG_HOME/tmux/tmux.conf
    rm -rf $XDG_CONFIG_HOME/nvim
    rm -rf $XDG_CONFIG_HOME/zsh/init.zsh
    ZSHPLUG=$THISDIR/zsh/plugins
    if [ -e $ZSHPLUG ]; then
        for i in $(find $ZSHPLUG -name "*.plugin.zsh"); do
            dname=$(dirname $i)
            rm -rf $XDG_CONFIG_HOME/zsh/plugins/$(basename $dname)
        done
    fi
    info "All cleansed!"
}

# Change to 0 to install a copy instead of soft link
SOFTLINK=1
WITHDEPS=0
while getopts fsech opt; do
    case $opt in
    f) SOFTLINK=0 ;;
    s) SOFTLINK=1 ;;
    e) WITHDEPS=1 ;;
    c) cleanse_all && exit 0 ;;
    h | ?) usage && exit 0 ;;
    esac
done

if [ "x$WITHDEPS" == "x1" ]; then
    check_sudo_access
    install_zsh_deps
    #install_vim_deps
    install_neovim_deps
fi
handle_zsh && handle_tmux && handle_neovim && handle_emacs
install_local_bins

info "Installed successfully!"
