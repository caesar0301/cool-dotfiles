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
ZSH_BUNDLES="${ZSH_CONFIG_DIR}/bundles/"
ZSH_PLUGIN_DIR="${ZSH_CONFIG_DIR}/plugins/"

# extra envs
export ZSH_CONFIG_DIR=${ZSH_CONFIG_DIR}
export ZSH_PLUGIN_DIR=${ZSH_PLUGIN_DIR}

# add local bin
export PATH=$PATH:$HOME/.local/bin

#+++++++++++++++++++++++++++++++++++++++
# ZI manager
#+++++++++++++++++++++++++++++++++++++++

autoload -Uz _zi && (( ${+_comps} )) && _comps[zi]=_zi

# Oh-My-Zsh libs
zinit ice wait lucid; zinit snippet OMZL::clipboard.zsh
zinit ice wait lucid; zinit snippet OMZL::compfix.zsh
zinit ice wait lucid; zinit snippet OMZL::completion.zsh
zinit ice wait lucid; zinit snippet OMZL::correction.zsh
zinit ice wait lucid; zinit snippet OMZL::directories.zsh
zinit ice wait lucid; zinit snippet OMZL::functions.zsh
zinit ice wait lucid; zinit snippet OMZL::git.zsh
zinit ice wait lucid; zinit snippet OMZL::spectrum.zsh
zinit ice wait lucid; zinit snippet OMZL::theme-and-appearance.zsh

# Efficiency
zinit ice wait lucid; zinit snippet OMZP::alias-finder
zinit ice wait lucid; zinit snippet OMZP::extract
zinit ice wait lucid; zinit snippet OMZP::vi-mode
zinit ice wait lucid; zinit snippet OMZP::fzf
zinit ice pick"z.sh" wait lucid; zinit load rupa/z

# Completion & search
zinit ice lucid wait='0' atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
zinit ice pick"src"; zinit light zsh-users/zsh-completions
fpath=($ZINIT_WORKDIR/plugins/zsh-users---zsh-completions/src $fpath)
zinit ice pick"zsh-history-substring-search.zsh"
zinit light zsh-users/zsh-history-substring-search
zinit ice pick "zsh-syntax-highlighting.zsh" wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# Theme
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Development
zinit ice wait lucid; zinit snippet OMZP::git
zinit ice wait lucid; zinit snippet OMZP::colored-man-pages

## Python
function _setupPyenv {
    if [ -e "$HOME/.pyenv" ]; then
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        if command -v pyenv 1>/dev/null 2>&1; then
            eval "$(pyenv init --path)"
        fi
    fi
}
_setupPyenv

# Load custom bundles
for i in `find ${ZSH_BUNDLES} -maxdepth 1 -type f -name "*.zsh"`; do
    zinit ice wait lucid; zinit snippet $i;
done

# Load custom extensions under $ZSH_PLUGIN_DIR
function _load_custom_extensions {
    if [ -e ${ZSH_PLUGIN_DIR} ]; then
        # Load plugins
        for plugin in $(ls -d $ZSH_PLUGIN_DIR/*); do
            zinit ice wait lucid; zinit light $plugin
        done
        # Load plain zsh scripts
        for i in `find ${ZSH_PLUGIN_DIR} -maxdepth 1 -type f -name "*.zsh"`; do
            zinit ice wait lucid; zinit light $i;
        done
    fi
}
_load_custom_extensions

autoload -U parseopts zargs zcalc zed zmv
autoload -U compinit && compinit
zinit cdreplay -q
#zinit cdlist

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

# Reload zshrc globally
function zshld {
    myextdir=$(basename $(echo "${ZSH_PLUGIN_DIR}" | sed -E -n "s|(.*[^/])/?|\1|p"))
    if [ -e $ZINIT_WORKDIR ]; then
        ls -d $ZINIT_WORKDIR/snippets/* | grep "$myextdir" | xargs rm -rf
    fi
    source $HOME/.zshrc
}
