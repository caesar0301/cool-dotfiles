#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

SHFMT_VERSION="v3.7.0"
ZSH_VERSION="5.8"

# load common utils
source $THISDIR/lib/bash_utils.sh

function install_local_bins {
    mkdir_nowarn $HOME/.local/bin
    cp $THISDIR/local_bin/* $HOME/.local/bin
}

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
    fi
}

function install_rbenv {
    if [ ! -e $HOME/.rbenv ]; then
        info "Installing rbenv to $HOME/.rbenv..."
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
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
        mkdir_nowarn $dpath >/dev/null
        curl -L --progress-bar $jdtlink | tar zxf - -C $dpath
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
        mkdir_nowarn $FONTDIR
        curl -L --progress-bar ttps://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.tar.xz | tar xJ -C $FONTDIR
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
    shfmtfile="shfmt_${SHFMT_VERSION}_linux_amd64"
    if [ "$(uname)" == "Darwin" ]; then
        shfmtfile="shfmt_${SHFMT_VERSION}_darwin_amd64"
    fi
    mkdir_nowarn $HOME/.local/bin
    curl -L --progress-bar https://github.com/mvdan/sh/releases/download/${SHFMT_VERSION}/$shfmtfile -o $HOME/.local/bin/shfmt
    chmod +x $HOME/.local/bin/shfmt
}

# Autoformat wrapper, for more refer to
# https://github.com/vim-autoformat/vim-autoformat/blob/master/README.md
function install_autoformat_deps {
    info "Installing vim-autoformat dependencies..."

    install_google_java_format

    # pip
    piplibs=(pip pynvim black sqlparse cmake_format)
    if check_command pip; then
        if [[ ${#piplibs[@]} > 0 ]]; then
            info "Installing pip deps: $piplibs"
            pip install -U ${piplibs[@]}
        fi
    else
        warn "Command pip not found, install and try again."
    fi

    # npm
    npmlibs=()
    if ! check_command js-beautify; then
        npmlibs+=(js-beautify)
    fi
    if ! check_command remark; then
        npmlibs+=(remark-cli)
    fi
    if ! check_command html-beautify; then
        npmlibs+=(html-beautify)
    fi
    if ! check_command luafmt; then
        npmlibs+=(lua-fmt)
    fi
    if ! check_command scmindent; then
        npmlibs+=(scmindent)
    fi
    if ! check_command yaml-language-server; then
        npmlibs+=(yaml-language-server)
    fi
    if check_command npm; then
        if [[ ${#npmlibs[@]} > 0 ]]; then
            info "Installing npm deps: $npmlibs"
            sudo npm install --quiet --force -g ${npmlibs[@]}
        fi
    else
        warn "Command npm not found, install and try again."
    fi

    # gem
    gemlibs=()
    if ! check_command ruby-beautify; then
        gemlibs+=(ruby-beautify)
    fi
    if command -v gem; then
        if [[ ${#gemlibs[@]} > 0 ]]; then
            info "Installing gem deps: $gemlibs"
            sudo gem install --quiet $gemlibs
        fi
    else
        warn "Command gem not found, install and try again."
    fi

    # shfmt
    if ! check_command shfmt; then
        install_shfmt
    fi
}

function install_lsp_deps {
    info "Install LSP dependencies..."
    piplibs=(pyright)
    if check_command pip; then
        if [[ ${#piplibs[@]} > 0 ]]; then
            info "Installing pip deps: $piplibs"
            pip install -U ${piplibs[@]}
        fi
    else
        warn "Command pip not found, install and try again."
    fi

}

function install_zsh {
    info "Installing zsh..."
    mkdir_nowarn $HOME/.local/bin
    mkdir_nowarn /tmp/build-zsh
    curl -L --progress-bar http://ftp.funet.fi/pub/unix/shells/zsh/zsh-${ZSH_VERSION}.tar.xz | tar xJ -C /tmp/build-zsh/
    cd /tmp/build-zsh/zsh-${ZSH_VERSION} && ./configure --prefix $HOME/.local && make && make install && cd -
}

function install_vim_deps {
    install_fzf
    install_jdt_language_server
    install_autoformat_deps
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

function install_all_deps {
    install_pyenv
    install_jenv
    install_rbenv
    install_fzf
    install_jdt_language_server
    # required by nvim-web-devicons
    install_hack_nerd_font
    install_autoformat_deps
    install_ossutil
    #install_vim_deps
    if ! check_command zsh; then
        install_zsh
    fi
}

############################################################################

function handle_zsh {
    mkdir_nowarn $XDG_CONFIG_HOME/zsh

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
    $CMD $THISDIR/zsh/bundles $XDG_CONFIG_HOME/zsh/bundles

    # Install bundled plugins
    mkdir_nowarn $XDG_CONFIG_HOME/zsh/plugins
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
    mkdir_nowarn $XDG_CONFIG_HOME/tmux
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $THISDIR/tmux/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
        ln -sf $THISDIR/tmux/tmux.conf.local $XDG_CONFIG_HOME/tmux/tmux.conf.local
    else
        cp $THISDIR/tmux/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
        cp $THISDIR/tmux/tmux.conf.local $XDG_CONFIG_HOME/tmux/tmux.conf.local
    fi
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

function usage {
    info "Usage: install_dotfiles.sh [-f] [-s] [-e]"
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
    c) cleanse_all && exit 0 ;;
    h | ?) usage && exit 0 ;;
    esac
done

if [ "x$WITHDEPS" == "x1" ]; then
    check_sudo_access
    install_all_deps
fi

install_local_bins

handle_all

info "Installed successfully!"
