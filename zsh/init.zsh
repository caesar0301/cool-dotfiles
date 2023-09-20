#############################################################
# Filename: ~/.config/zsh/init.zsh
#     About: init script of zsh
#     Maintained by xiaming.cxm, updated 2023-05-11
#
# Plugins:
#     We recommend extend custom zsh settings via plugins.
#     You can put any plugin or zsh-suffixed scripts in
#     ~/.config/zsh/plugins to make them work.
#############################################################

# Install zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

ZINIT_WORKDIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
ZSH_CONFIG_DIR="${HOME}/.config/zsh"
ZSH_PLUGIN_DIR="${HOME}/.config/zsh/plugins"

# extra envs
export ZSH_CONFIG_DIR=${ZSH_CONFIG_DIR}
export ZSH_PLUGIN_DIR=${ZSH_PLUGIN_DIR}

# add local bin
export PATH=$PATH:$HOME/.local/bin

#+++++++++++++++++++++++++++++++++++++++
# ZI manager
#+++++++++++++++++++++++++++++++++++++++

autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

# Oh-My-Zsh libs
zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::compfix.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::correction.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::functions.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZL::spectrum.zsh
zinit snippet OMZL::theme-and-appearance.zsh

# Efficiency
zinit snippet OMZP::alias-finder
zinit snippet OMZP::extract
zinit snippet OMZP::vi-mode
zinit snippet OMZP::fzf
zinit ice pick"z.sh"
zinit load rupa/z

# Colored
zinit snippet OMZP::colored-man-pages

# Dev
zinit snippet OMZP::git
zinit snippet OMZP::gitignore

# Web
zi snippet OMZP::urltools
zi ice svn
zi snippet OMZP::shell-proxy

# Python
function _setupPyenv {
	# fix badly configured error of plugin
    # Consume 15% startup time
    if [ -e "$HOME/.pyenv" ]; then
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        if command -v pyenv 1>/dev/null 2>&1; then
            eval "$(pyenv init --path)"
        fi
    fi
}
_setupPyenv
zinit snippet OMZP::pyenv
zinit snippet OMZP::jenv
zinit snippet OMZP::rbenv
zinit snippet OMZP::virtualenv

# Theme
zinit cdclear -q
setopt promptsubst
zinit snippet OMZP::themes
#zinit snippet OMZT::robbyrussell
zinit snippet OMZT::jtriley
#zinit snippet OMZT::kafeitu
#zinit snippet OMZT::crcandy

# Completion
zinit ice pick"zsh-history-substring-search.zsh"
zinit load zsh-users/zsh-history-substring-search

zinit ice pick"src"
zinit load zsh-users/zsh-completions
fpath=($ZINIT_WORKDIR/plugins/zsh-users---zsh-completions/src $fpath)

# Fish-shell likes
zinit ice pick"zsh-autosuggestions.zsh"
zinit load zsh-users/zsh-autosuggestions
zinit ice pick "zsh-syntax-highlighting.zsh"
zinit load zsh-users/zsh-syntax-highlighting

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

# Load my extensions under $ZSH_PLUGIN_DIR
function _load_custom_extensions {
    if [ -e ${ZSH_PLUGIN_DIR} ]; then
        # Load plugins
        for plugin in $(ls -d $ZSH_PLUGIN_DIR/*); do
            zinit load $plugin
        done
        # Load plain zsh scripts
        for i in `find ${ZSH_PLUGIN_DIR} -maxdepth 1 -type f -name "*.zsh"`; do
            zinit snippet $i;
        done
    fi
}
_load_custom_extensions

# Reload zshrc globally
function zshld {
    myextdir=$(basename $(echo "${ZSH_PLUGIN_DIR}" | sed -E -n "s|(.*[^/])/?|\1|p"))
    if [ -e $ZINIT_WORKDIR ]; then
        ls -d $ZINIT_WORKDIR/snippets/* | grep "$myextdir" | xargs rm -rf
    fi
    source $HOME/.zshrc
}

# Update zinit and plugins
function zshup {
    old_path=$(pwd)
    if [ -e ${ZSH_PLUGIN_DIR} ]; then
        for plugin in $(ls -d $ZSH_PLUGIN_DIR/*); do
            if [ -e ${plugin}/.git ]; then
                echo -n "Updating plugin ${plugin}..."
                cd $plugin && git pull -q && echo "done" && cd ${old_path}
            fi
        done
    fi
    # self update
    zinit self-update
    # plugin update
    zinit update --parallel
}

# fzf init
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
