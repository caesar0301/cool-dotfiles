#+++++++++++++++++++++++++++++++++++++++
# PATH
#+++++++++++++++++++++++++++++++++++++++

# start or access tmux dev session
function bingo {
    if tmux info &> /dev/null; then
        echo "Do nothing, tmux server already running"
        return 0
    fi
    unset TMUX
    HOSTNAME=$(hostname | sed -E "s/\./_/g" | head -c 8)
    SESSION_NAME="bingo"
    tmux -u start-server
    tmux -u has-session -t ${SESSION_NAME}
    if [ $? != 0 ]; then
        tmux -u new-session -d -s ${SESSION_NAME}
    fi
    tmux -u attach -t ${SESSION_NAME}
}

# Overhead configrator for apps
function occ {
    subcommand=$1;
    if [ ! -z $subcommand ]; then
        shift
    fi
    case "$subcommand" in
        emacs|em) cf=$HOME/.emacs.d/init.el
        ;;
        vi|vim|nvim) cf=$HOME/.config/nvim/init.lua
        ;;
        zsh) cf=${ZSH_CONFIG_DIR}/init.zsh
            while getopts eh opt; do
                case $opt in
                    e)    cf=$HOME/.zshenv ;;
                    h|?)  echo "occ zsh [-e]" && return;;
                esac
            done
        ;;
        ssh) cf=$HOME/.ssh/config
        ;;
        tmux) cf=$HOME/.config/tmux/tmux.conf.local
        ;;
        clash) cf=$HOME/.config/clash/config.yaml
        ;;
        proxychains|pc) cf=/etc/proxychains.conf
        ;;
        yum) cf=/etc/yum.conf
        ;;
        apt) cf=/etc/apt/sources.list
        ;;
        conan) cf=$HOME/.conan2/profiles/default
        ;;
        * ) # Invalid subcommand
            if [ ! -z $subcommand ]; then  # Don't show if no subcommand provided
                echo "Invalid subcommand: $subcommand"
            fi
            echo "Usage: occ <emacs|em|vim|vi|zsh|ssh|tmux|clash|pc|yum|apt|conan>"
            return
        ;;
    esac
    ${=EDITOR} $cf
}

# Open file window
function openw {
    KNAME=$(uname -s)
    KREL=$(uname -r)
    EXE='nautilus'
    if [[ $KNAME == "Linux" ]]; then
        if [[ $KREL =~ "microsoft-standard" ]]; then
            EXE='explorer.exe'
        fi
    elif [[ $KNAME == "Darwin"  ]]; then
        EXE='open'
    fi
    $EXE $@
}

# update nvim plugins
function nvimup {
    nvim -c "PackerInstall" -c "PackerSync" \
        -c "TSInstall lua python java go scala"
}

# update dotfiles
function dotup {
    DOTHOME=${DOTHOME:-$HOME/.dotfiles}
    CURDIR=$(pwd)
    cd $DOTHOME && git pull && $DOTHOME/install_dotfiles.sh
    cd $CURDIR
    echo "$HOME/.dotfiles updated"
}
