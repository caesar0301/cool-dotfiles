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
    if [ -e $HOME/.local/bin ]; then
        mkdir -p $HOME/.local/bin
    fi
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
        curl -L -s https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.tar.xz | tar xJ -C $FONTDIR
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

# Autoformat wrapper, for more refer to
# https://github.com/vim-autoformat/vim-autoformat/blob/master/README.md
function install_autoformat_deps {
    info "Installing vim-autoformat dependencies..."

    install_google_java_format

    # pip
    piplibs=(pip pynvim black sqlformat cmake_format)
    if command -v pip 1>/dev/null 2>&1; then
        if [[ ${#piplibs[@]} > 0 ]]; then
            info "Installing pip deps: $piplibs"
            pip install -U ${piplibs[@]}
        fi
    else
        warn "Command pip not found, install and try again."
    fi

    # npm
    npmlibs=()
    if ! command -v js-beautify 1>/dev/null 2>&1; then
        npmlibs+=(js-beautify)
    fi
    if ! command -v remark 1>/dev/null 2>&1; then
        npmlibs+=(remark-cli)
    fi
    if ! command -v html-beautify 1>/dev/null 2>&1; then
        npmlibs+=(html-beautify)
    fi
    if ! command -v luafmt 1>/dev/null 2>&1; then
        npmlibs+=(lua-fmt)
    fi
    if ! command -v scmindent 1>/dev/null 2>&1; then
        npmlibs+=(scmindent)
    fi
    if ! command -v yaml-language-server 1>/dev/null 2>&1; then
        npmlibs+=(yaml-language-server)
    fi
    if command -v npm 1>/dev/null 2>&1; then
        if [[ ${#npmlibs[@]} > 0 ]]; then
            info "Installing npm deps: $npmlibs"
            sudo npm install --quiet --force -g ${npmlibs[@]}
        fi
    else
        warn "Command npm not found, install and try again."
    fi

    # gem
    gemlibs=()
    if ! command -v ruby-beautify 1>/dev/null 2>&1; then
        gemlibs+=(ruby-beautify)
    fi
    if command -v gem 1>/dev/null 2>&1; then
        if [[ ${#gemlibs[@]} > 0 ]]; then
            info "Installing gem deps: $gemlibs"
            sudo gem install --quiet $gemlibs
        fi
    else
        warn "Command gem not found, install and try again."
    fi

    # shfmt
    if ! command -v shfmt 1>/dev/null 2>&1; then
        info "Installing shfmt..."
        curl -sS https://webi.sh/shfmt | sh
    fi

    # Install perl first
    # cpan -i Perl::Tidy
}

function install_all_deps {
    install_pyenv
    install_fzf
    install_jdt_language_server
    install_hack_nerd_font #Required by nvim-web-devicons
    install_autoformat_deps
}

function install_vim_deps {
    install_fzf
    install_jdt_language_server
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

    if [ ! -e $HOME/.zshrc ] || [ -L $HOME/.zshrc ]; then
        # Do not overwrite user local configs
        cp $THISDIR/zsh/zshrc $HOME/.zshrc
    else
        warn "$HOME/.zsrhc existed, skip without rewriting"
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

function handle_shell_proxy {
    if [ ! -e $HOME/.config/proxy ] || [ -L $HOME/.config/proxy ]; then
        if [ x$SOFTLINK == "x1" ]; then
            ln -sf $THISDIR/zsh/proxy-config $HOME/.config/proxy
        else
            cp $THISDIR/zsh/proxy-config $HOME/.config/proxy
        fi
    else
        warn "$HOME/.config/proxy existed, skip without rewriting"
    fi
}

function handle_all {
    handle_zsh
    handle_tmux
    handle_neovim
    handle_emacs
    handle_ctags
    handle_rlwrap
    handle_shell_proxy
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
    rm -rf $HOME/.ctags
    rm -rf $HOME/.sbcl_completions
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
    install_all_deps
    #install_vim_deps
fi

install_local_bins

handle_all

info "Installed successfully!"
