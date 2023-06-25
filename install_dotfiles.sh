#!/bin/bash
abspath=$(cd ${0%/*} && echo $PWD/${0##*/})
thispath=$(dirname $abspath)

function handle_zsh() {
    if [ ! -e $HOME/.zi ]; then
        mkdir -p "$HOME/.zi/bin"
        mkdir -p "$HOME/.zi/completions"
        git clone https://github.com/z-shell/zi.git "$HOME/.zi/bin"
    fi
    if [ ! -e $HOME/.config/zsh_runtime/plugins ]; then
        mkdir -p $HOME/.config/zsh_runtime/plugins
    fi
    CMD="cp -r"
    if [ x$SOFTLINK == "x1" ]; then
        CMD="ln -sf"
    fi
    $CMD $thispath/zsh/.zshrc $HOME/.zshrc
    for i in $(find $thispath/zsh/plugins -name "*.plugin.zsh"); do
        dname=$(dirname $i)
        $CMD $dname $HOME/.config/zsh_runtime/plugins/
    done
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

function handle_neovim() {
    # install plugin manager
    packer_home=$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
    if [ ! -e ${packer_home} ]; then
        echo "Install plugin manager Packer..."
        git clone --depth 1 https://github.com/wbthomason/packer.nvim \
            ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi
    # install nerd patched font Hack, required by nvim-web-devicons
    echo "Install Hack nerd font and update font cache..."
    if ! $(fc-list | grep "Hack Nerd Font" >/dev/null); then
        curl -L --progress-bar https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.tar.xz |
            tar xJ -C $HOME/.local/share/fonts/
    fi
    fc-cache -f
    # install nvim configs by copy
    ln -sf $thispath/neovim/.config/nvim $HOME/.config/
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

function install_pyenv() {
    if [ -e $HOME/.pyenv ]; then
        echo "$HOME/.pyenv existed, skip"
    else
        git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
    fi
}

function install_fzf() {
    UNAMEO=$(uname -s)
    if [ x$UNAMEO == "xLinux" ] || [ x$UNAMEO == "xCYGWIN" ] || [ x$UNAMEO == "xMINGW" ]; then
        if [ -e $HOME/.fzf ]; then
            echo "$HOME/.fzf existed, skip"
        else
            git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
            $HOME/.fzf/install
        fi
    elif [ x$UNAMEO == "xDarwin" ]; then
        brew install fzf
        $(brew --prefix)/opt/fzf/install
    fi
}

# Required by nvim-jdtls
function install_jdt_language_server {
    jdtlink="https://download.eclipse.org/jdtls/milestones/1.23.0/jdt-language-server-1.23.0-202304271346.tar.gz"
    dfile=/tmp/jdt-language-server.tar.gz
    dpath=$HOME/.local/share/jdt-language-server
    if [ -e "$dfile" ]; then
        echo "Existing file $dfile, skip downloading"
    else
        wget $jdtlink -O /tmp/jdt-language-server.tar.gz
    fi
    if [ -e $dpath ]; then
        echo "Non-empty target path [$dpath], assuming jdtls already installed"
        return 0
    else
        mkdir -p $dpath
    fi
    echo "jdtls extracted to $dpath"
    tar zxf $dfile -C $dpath
}

function install_deps {
    # autoformat
    sudo npm install -g remark-cli js-beautify
    gem install ruby-beautify
    install_pyenv
    install_fzf
    install_jdt_language_server
}

function configure_dotfiles {
    handle_zsh
    handle_tmux
    #handle_vim
    handle_neovim
    handle_emacs
}

# Change to 0 to install a copy instead of soft link
SOFTLINK=1
WITHDEPS=0
while getopts se opt; do
    case $opt in
    f) SOFTLINK=0 ;;
    e) WITHDEPS=1 ;;
    h | ?) echo "install.sh [-f] [-e]" && return ;;
    esac
done

if [ "x$WITHDEPS" == "x1" ]; then
    install_deps
fi

configure_dotfiles
