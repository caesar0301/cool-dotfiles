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

export PLUGIN_HOME="${HOME}/.config/zsh/plugins"

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

# fzf init
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
