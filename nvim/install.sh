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

# load common utils
source $THISDIR/../lib/bash_utils.sh

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
        curl -L --progress-bar https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.tar.xz | tar xJ -C $FONTDIR
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
    if checkcmd pip; then
        if [[ ${#piplibs[@]} > 0 ]]; then
            info "Installing pip deps: $piplibs"
            pip install -U ${piplibs[@]}
        fi
    else
        warn "Command pip not found, install and try again."
    fi

    # npm
    npmlibs=()
    if ! checkcmd js-beautify; then
        npmlibs+=(js-beautify)
    fi
    if ! checkcmd remark; then
        npmlibs+=(remark-cli)
    fi
    if ! checkcmd html-beautify; then
        npmlibs+=(html-beautify)
    fi
    if ! checkcmd luafmt; then
        npmlibs+=(lua-fmt)
    fi
    if ! checkcmd scmindent; then
        npmlibs+=(scmindent)
    fi
    if ! checkcmd yaml-language-server; then
        npmlibs+=(yaml-language-server)
    fi
    if checkcmd npm; then
        if [[ ${#npmlibs[@]} > 0 ]]; then
            info "Installing npm deps: $npmlibs"
            sudo npm install --quiet --force -g ${npmlibs[@]}
        fi
    else
        warn "Command npm not found, install and try again."
    fi

    # gem
    gemlibs=()
    if ! checkcmd ruby-beautify; then
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
    if ! checkcmd shfmt; then
        install_shfmt
    fi
}

function install_lsp_deps {
    info "Install LSP dependencies..."
    piplibs=(pyright)
    if checkcmd pip; then
        if [[ ${#piplibs[@]} > 0 ]]; then
            info "Installing pip deps: $piplibs"
            pip install -U ${piplibs[@]}
        fi
    else
        warn "Command pip not found, install and try again."
    fi

    info "Install R language server..."
    if checkcmd R; then
        if ! $(R -e "library(languageserver)" >/dev/null); then
            R -e "install.packages('languageserver', repos='https://mirrors.nju.edu.cn/CRAN/')"
        fi
    fi
}

function install_all_deps {
    install_lsp_deps
    install_jdt_language_server
    install_hack_nerd_font # required by nvim-web-devicons
    install_autoformat_deps
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

function handle_neovim {
    # install plugin manager
    packer_home=$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
    if [ ! -e ${packer_home} ]; then
        info "Install plugin manager Packer..."
        git clone --depth 1 https://github.com/wbthomason/packer.nvim \
            ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $THISDIR $XDG_CONFIG_HOME/
    else
        cp -r $THISDIR $XDG_CONFIG_HOME/
    fi
}

function cleanse_all {
    rm -rf $HOME/.ctags
    rm -rf $XDG_CONFIG_HOME/nvim
    info "All nvim cleansed!"
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

handle_ctags
handle_neovim

info "Successed! Run :PackerInstall to install nvim plugins"
