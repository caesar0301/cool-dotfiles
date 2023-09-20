#############################################################
# Filename: ~/.config/zsh/init.zsh
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
#     ~/.config/zsh/plugins to make them work.
#############################################################
ZI_HOME="${HOME}/.zi"
ZSH_CONFIG_DIR="${HOME}/.config/zsh"
ZSH_PLUGIN_DIR="${HOME}/.config/zsh/plugins"

# extra envs
export ZI_HOME=${ZI_HOME}
export ZSH_CONFIG_DIR=${ZSH_CONFIG_DIR}
export ZSH_PLUGIN_DIR=${ZSH_PLUGIN_DIR}

# add local bin
export PATH=$PATH:$HOME/.local/bin

#+++++++++++++++++++++++++++++++++++++++
# ZI manager
#+++++++++++++++++++++++++++++++++++++++

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

# Web
zi snippet OMZP::urltools
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
zi snippet OMZP::pyenv
zi snippet OMZP::jenv
zi snippet OMZP::rbenv
zi snippet OMZP::virtualenv

# Theme
zi cdclear -q
setopt promptsubst
zi snippet OMZP::themes
#zi snippet OMZT::robbyrussell
zi snippet OMZT::jtriley
#zi snippet OMZT::kafeitu
#zi snippet OMZT::crcandy

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

# Load my extensions under $ZSH_PLUGIN_DIR
function _load_custom_extensions {
    if [ -e ${ZSH_PLUGIN_DIR} ]; then
        # Load plugins
        for plugin in $(ls -d $ZSH_PLUGIN_DIR/*); do
            zi load $plugin
        done
        # Load plain zsh scripts
        for i in `find ${ZSH_PLUGIN_DIR} -maxdepth 1 -type f -name "*.zsh"`; do
            zi snippet $i;
        done
    fi
}
_load_custom_extensions

# Reload zshrc globally
function zshld {
    myextdir=$(basename $(echo "${ZSH_PLUGIN_DIR}" | sed -E -n "s|(.*[^/])/?|\1|p"))
    if [ -e $HOME/.zi ]; then
        ls -d $HOME/.zi/snippets/* | grep "$myextdir" | xargs rm -rf
    fi
    source $HOME/.zshrc
}

# Update zsh plugins
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
    echo -n "Updating ${ZI_HOME}/bin..."
    cd ${ZI_HOME}/bin && git pull -q && echo "done" && cd ${old_path}
}

# fzf init
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
