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

# Update zinit and plugins
function zshup {
    # self update
    zinit self-update
    # plugin update
    zinit update --parallel
    # update user plugins
    old_path=$(pwd)
    if [ -e ${ZSH_PLUGIN_DIR} ]; then
        for plugin in $(ls -d $ZSH_PLUGIN_DIR/*); do
            if [ -e ${plugin}/.git ]; then
                echo -n "Updating plugin ${plugin}..."
                cd $plugin && git pull -q && echo "done" && cd ${old_path}
            fi
        done
    fi
}

# update nvim plugins
function nvimup {
    nvim --headless -c "PackerClean" -c "PackerUpdate" -c "TSUpdate" -c 'qall'
}

# Edit configurations
function occ {
    subcommand=$1;
    if [ ! -z $subcommand ]; then
        shift
    fi
    case "$subcommand" in
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
        emacs|em) cf=$HOME/.emacs.d/init.el
        ;;
        vi|vim|nvim) cf=$HOME/.config/nvim/init.lua
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
        kitty) cf=$HOME/.config/kitty/kitty.conf
        ;;
        * ) # Invalid subcommand
            if [ ! -z $subcommand ]; then  # Don't show if no subcommand provided
                echo "Invalid subcommand: $subcommand"
            fi
            echo "Usage: occ <emacs|em|vim|vi|zsh|ssh|tmux|clash|pc|yum|apt|conan|kitty>"
            return
        ;;
    esac
    ${=EDITOR} $cf
}
