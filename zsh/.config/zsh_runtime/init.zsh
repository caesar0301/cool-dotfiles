#############################################################
# Filename: ~/.config/zsh_runtime/init.zsh
#     About: init script of zsh
#     Maintained by xiaming.cxm, updated 2023-05-11
#
# Install:
#     mkdir -p ~/.zi/completions
#     git clone https://github.com/z-shell/zi.git ~/.zi/bin
#
# Plugins:
#     We recommend extend custom zsh settings via plugins.
#     You can put any plugin or zsh-suffixed scripts in
#     ~/.config/zsh_runtime/plugins to make them work.
#############################################################

#+++++++++++++++++++++++++++++++++++++++
# ZI manager
#+++++++++++++++++++++++++++++++++++++++

ZI_HOME="${HOME}/.zi"
source "${ZI_HOME}/bin/zi.zsh"

autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

# Oh-My-Zsh libs
zi snippet OMZL::clipboard.zsh
zi snippet OMZL::compfix.zsh
zi snippet OMZL::completion.zsh
zi snippet OMZL::correction.zsh
zi snippet OMZL::directories.zsh
zi snippet OMZL::functions.zsh
zi snippet OMZL::git.zsh
zi snippet OMZL::spectrum.zsh
zi snippet OMZL::theme-and-appearance.zsh

# Efficiency
zi snippet OMZP::alias-finder
zi snippet OMZP::extract
zi snippet OMZP::vi-mode
zi snippet OMZP::fzf
zi ice pick"z.sh"
zi load rupa/z

# Colored
zi snippet OMZP::colored-man-pages

# Dev
zi snippet OMZP::git
zi snippet OMZP::gitignore
zi snippet OMZP::mvn

# Web
zi snippet OMZP::urltools

# Python
function _setupPyenv {
    # Consume 15% startup time
    if [ -e "$HOME/.pyenv" ]; then
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        if command -v pyenv 1>/dev/null 2>&1; then
            # Load pyenv automatically
            eval "$(pyenv init --path)"
        fi
    fi
}
_setupPyenv
zi snippet OMZP::pyenv
zi snippet OMZP::virtualenv

# Theme
zi cdclear -q
setopt promptsubst
#zi snippet OMZT::robbyrussell
#zi snippet OMZT::jtriley
zi snippet OMZT::kafeitu
zi snippet OMZP::themes

# Completion
zi ice pick"zsh-history-substring-search.zsh"
zi load zsh-users/zsh-history-substring-search

zi ice pick"src"
zi load zsh-users/zsh-completions
fpath=($HOME/.zi/plugins/zsh-users---zsh-completions/src $fpath)

# Fish-shell likes
zi ice pick"zsh-autosuggestions.zsh"
zi load zsh-users/zsh-autosuggestions
zi ice pick "zsh-syntax-highlighting.zsh"
zi load zsh-users/zsh-syntax-highlighting

# Profiling perf
if [[ ${PROFILE_PERF} == 1 ]]; then
    zprof
fi

#+++++++++++++++++++++++++++++++++++++++
# Basics and commons
#+++++++++++++++++++++++++++++++++++++++

# Editor
export EDITOR=nvim

# zsh history
export HISTFILE=$HOME/.zhistory
export HISTSIZE=9999
export SAVEHIST=9999

# Disable Ctrl+D to close session
setopt IGNORE_EOF

# Diagnose perf
PROFILE_PERF=0
if [[ ${PROFILE_PERF} == 1 ]]; then
    zmodload zsh/zprof
fi

# zsh bundled
autoload -U parseopts
autoload -U zargs
autoload -U zcalc
autoload -U zed
autoload -U zmv
autoload -U compinit && compinit

export PLUGIN_HOME="${HOME}/.config/zsh_runtime/plugins"

# Reload zshrc globally
function zshld {
    myextdir=$(basename $(echo "${PLUGIN_HOME}" | sed -E -n "s|(.*[^/])/?|\1|p"))
    if [ -e $HOME/.zi ]; then
        ls -d $HOME/.zi/snippets/* | grep "$myextdir" | xargs rm -rf
    fi
    source $HOME/.zshrc
}

# Update zsh plugins
function zshup {
    old_path=$(pwd)
    if [ -e ${PLUGIN_HOME} ]; then
        for plugin in $(ls -d $PLUGIN_HOME/*); do
            if [ -e ${plugin}/.git ]; then
                echo -n "Updating plugin ${plugin}..."
                cd $plugin && git pull -q && echo "done" && cd ${old_path}
            fi
        done
    fi
    echo -n "Updating ${ZI_HOME}/bin..."
    cd ${ZI_HOME}/bin && git pull -q && echo "done" && cd ${old_path}
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
        vi|vim) cf=$HOME/.vimrc
        ;;
        nvim) cf=$HOME/.config/nvim/init.lua
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


# Load my extensions under $PLUGIN_HOME
function _load_custom_extensions {
    if [ -e ${PLUGIN_HOME} ]; then
        # Load plugins
        for plugin in $(ls -d $PLUGIN_HOME/*); do
            zi load $plugin
        done
        # Load plain zsh scripts
        for i in `find ${PLUGIN_HOME} -maxdepth 1 -type f -name "*.zsh"`; do
            zi snippet $i;
        done
    fi
}
_load_custom_extensions

# fzf init
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#+++++++++++++++++++++++++++++++++++++++
# Useful alias
#+++++++++++++++++++++++++++++++++++++++

# Perf
alias psmem="ps -o pid,user,%mem,command ax | sort -b -k3 -r"

# Editor
alias em='emacs -nw'
alias diffr='diff -r'

# Stat.
alias duh="du -hs .[^.]*"
