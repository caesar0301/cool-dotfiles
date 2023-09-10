#+++++++++++++++++++++++++++++++++++++++
# PATH
#+++++++++++++++++++++++++++++++++++++++
export PATH=$PATH:$HOME/.local/bin

# shortcuts to applications installed by flatpak
if command -v flatpak &> /dev/null; then
    # Add flatpak shortcuts
    export PATH=$PATH:/var/lib/flatpak/exports/bin
fi

#+++++++++++++++++++++++++++++++++++++++
# Useful alias
#+++++++++++++++++++++++++++++++++++++++

# Perf
alias psmem="ps -o pid,user,%mem,command ax | sort -b -k3 -r"

# Editor
alias vi=nvim
alias em='emacs -nw'
alias diffr='diff -r'

# Stat.
alias duh="du -hs .[^.]*"

# StarDict console
# Install dicts into ~/.local/share/stardict/dic or /usr/share/stardict/dic
alias dict="sdcv -0 -c"

# Rsync preseving symlinks, timestamps, permissions
alias rsync2="rsync -rlptgoD --progress"

# Alias from flatpak exports
function _generate_flatpak_alias {
    flatpak_exports=/var/lib/flatpak/exports/bin
    for i in `ls ${flatpak_exports}`; do
        alias run-$i="flatpak run $i"
    done
    # Specifically
    alias code="flatpak run com.visualstudio.code"
}
_generate_flatpak_alias 

# Alias for AppImages in ~/.local/share/appimage
function _generate_appimages_alias {
    appimage_dir=$HOME/.local/share/appimages
    if [ -e ${appimage_dir} ]; then
        for i in `find ${appimage_dir} -name "*.AppImage"`; do
            filename=$(basename -- "$i")
            alias run-${filename%.*}="${i}"
        done
    fi
}
_generate_appimages_alias

#+++++++++++++++++++++++++++++++++++++++
# Useful functions
#+++++++++++++++++++++++++++++++++++++++

function replace {
    sourcestr="$1"
    targetstr="$2"
    pathstr="$3"
    grep -r $sourcestr $pathstr | awk -F: '{print $1}' | uniq | xargs -I@ sed -i.old -E "s|$sourcestr|$targetstr|g" @
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
        zsh) cf=$HOME/.config/zsh_runtime/init.zsh
            while getopts eh opt; do
                case $opt in
                    e)    cf=$HOME/.zshenv ;;
                    h|?)  echo "occ zsh [-e]" && return;;
                esac
            done
        ;;
        ssh) cf=$HOME/.ssh/config
        ;;
        tmux) cf=$HOME/.tmux.conf
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
