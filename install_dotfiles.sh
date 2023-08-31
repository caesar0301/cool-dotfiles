#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Usage:
# # Install dotfiles by soft links
# ./install_dotfiles.sh
#
# # Install dotfiles by copying
#    ./install_dotfiles.sh -f
#
# # With essential dependencies
# ./install_dotfiles.sh -f -e
# Maintainer:
# xiaming.cxm
###################################################
abspath=$(cd ${0%/*} && echo $PWD/${0##*/})
thispath=$(dirname $abspath)

function usage() {
    echo "Usage: install_dotfiles.sh [-f] [-e]"
}

function install_pyenv() {
    if [ ! -e $HOME/.pyenv ]; then
        echo "Installing pyenv to $HOME/.pyenv..."
        git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
    fi
}

function install_fzf() {
    if [ ! -e $HOME/.fzf ]; then
        echo "Installing fzf to $HOME/.fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
        $HOME/.fzf/install
    fi
}

# Required by nvim-jdtls
function install_jdt_language_server() {
    jdtlink="https://download.eclipse.org/jdtls/milestones/1.23.0/jdt-language-server-1.23.0-202304271346.tar.gz"
    dpath=$HOME/.local/share/jdt-language-server
    if [ ! -e $dpath/bin/jdtls ]; then
        echo "Installing jdt-language-server to $dpath..."
        mkdir -p $dpath >/dev/null
        curl -L --progress-bar $jdtlink | tar zxf -C $dpath
    fi
}

function install_hack_nerd_font() {
    # install nerd patched font Hack, required by nvim-web-devicons
    if ! $(fc-list | grep "Hack Nerd Font" >/dev/null); then
        echo "Install Hack nerd font and update font cache..."
        if [ ! -e $HOME/.local/share/fonts ]; then
            mkdir -p $HOME/.local/share/fonts
        fi
        curl -L --progress-bar https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.tar.xz \
            | tar xJ -C $HOME/.local/share/fonts/
        fc-cache -f
    fi
}

function install_google_java_format() {
    rfile="https://github.com/google/google-java-format/releases/download/v1.17.0/google-java-format-1.17.0-all-deps.jar"
    dpath=$HOME/.local/share/google-java-format
    if ! compgen -G "$dpath/google-java-format*.jar" >/dev/null; then
        echo "Installing google-java-format to $dpath..."
        curl -L --progress-bar --create-dirs $rfile -o $dpath/google-java-format-all-deps.jar
    fi
}

function install_shfmt {
    curl -sS https://webi.sh/shfmt | sh
}

function install_autoformat_deps() {
    echo "Installing vim-autoformat dependencies..."
    ############################################
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
    ############################################
    pip install -U black sqlformat cmake_format
    sudo npm install --quiet -g remark-cli js-beautify lua-fmt scmindent
    sudo gem install --quiet ruby-beautify
    install_google_java_format
    install_shfmt
    # Install perl first
    # cpan -i Perl::Tidy
}

function handle_zsh() {
    # Install ZI
    if [ ! -e $HOME/.zi ]; then
        mkdir -p "$HOME/.zi/bin"
        mkdir -p "$HOME/.zi/completions"
        git clone https://github.com/z-shell/zi.git "$HOME/.zi/bin"
    fi

    if [ ! -e $HOME/.zshrc ]; then
        # Do not overwrite user local configs
        cp $thispath/zsh/.zshrc $HOME/.zshrc
    else
        echo "$HOME/.zsrhc existed. Skip without rewriting"
    fi

    FROM_DIR=$thispath/zsh/.config/zsh_runtime
    TARGET_DIR=$HOME/.config/zsh_runtime
    if [ x$SOFTLINK == "x1" ]; then
        CMD="ln -sf"
    else
        CMD="cp -r"
    fi
    $CMD $FROM_DIR/init.zsh $TARGET_DIR/init.zsh

    # Install our plugins
    if [ ! -e $TARGET_DIR/plugins ]; then
        mkdir -p $TARGET_DIR/plugins
    fi
    for i in $(find $FROM_DIR/plugins -name "*.plugin.zsh"); do
        dname=$(dirname $i)
        $CMD $dname $TARGET_DIR/plugins/
    done
}

function install_zsh_deps() {
    install_pyenv
}

function handle_vim() {
    # install vim-plug manager
    curl --progress-bar -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $thispath/vim/.vimrc $HOME/.vimrc
    else
        cp $thispath/vim/.vimrc $HOME/.vimrc
    fi
}

function install_vim_deps() {
    install_fzf
    install_jdt_language_server
    install_autoformat_deps
}

function handle_neovim() {
    # install plugin manager
    packer_home=$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
    if [ ! -e ${packer_home} ]; then
        echo "Install plugin manager Packer..."
        git clone --depth 1 https://github.com/wbthomason/packer.nvim \
            ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $thispath/neovim/.config/nvim $HOME/.config/
    else
        cp -r $thispath/neovim/.config/nvim $HOME/.config/
    fi
}

function install_neovim_deps() {
    install_fzf
    install_jdt_language_server
    install_hack_nerd_font #Required by nvim-web-devicons
    install_autoformat_deps
}

function handle_tmux() {
    mkdir -p $HOME/.tmux/plugins
    if [ ! -e $HOME/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    fi
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $thispath/tmux/tmux.conf $HOME/.tmux.conf
    else
        cp $thispath/tmux/tmux.conf $HOME/.tmux.conf
    fi
}

function handle_emacs() {
    if [ ! -e $HOME/.emacs.d ]; then
        mkdir ~/.emacs.d
    fi
    if [ -e $HOME/.emacs.d/settings ]; then
        rm -rf $HOME/.emacs.d/settings
    fi
    if [ x$SOFTLINK == "x1" ]; then
        ln -sf $thispath/emacs/.emacs.d/settings $HOME/.emacs.d/settings
        ln -sf $thispath/emacs/.emacs.d/init.el $HOME/.emacs.d/init.el
    else
        cp -r $thispath/emacs/.emacs.d/settings $HOME/.emacs.d/
        cp $thispath/emacs/.emacs.d/init.el $HOME/.emacs.d/
    fi
}

# Change to 0 to install a copy instead of soft link
SOFTLINK=1
WITHDEPS=0
while getopts se opt; do
    case $opt in
    f) SOFTLINK=0 ;;
    e) WITHDEPS=1 ;;
    h | ?) usage && exit 0 ;;
    esac
done

if [ "x$WITHDEPS" == "x1" ]; then
    install_zsh_deps
    #install_vim_deps
    install_neovim_deps
fi
handle_zsh && handle_tmux && handle_neovim && handle_emacs

echo "Installed successfully!"
