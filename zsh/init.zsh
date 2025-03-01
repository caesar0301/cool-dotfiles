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
ZSH_CONFIG_DIR="${HOME}/.config/zsh"
ZSH_PLUGIN_DIR="${ZSH_CONFIG_DIR}/plugins/"
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
ZINIT_WORKDIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
source "${ZINIT_HOME}/zinit.zsh"

# extra envs
export ZSH_CONFIG_DIR=${ZSH_CONFIG_DIR}
export ZSH_PLUGIN_DIR=${ZSH_PLUGIN_DIR}

###------------------------------------------------
### ZI MANAGER
###------------------------------------------------

autoload -Uz _zi && (( ${+_comps} )) && _comps[zi]=_zi

# Oh-My-Zsh libs
zinit ice wait lucid; zinit snippet OMZL::clipboard.zsh
zinit ice wait lucid; zinit snippet OMZL::completion.zsh
zinit ice wait lucid; zinit snippet OMZL::functions.zsh
zinit ice wait lucid; zinit snippet OMZL::git.zsh
zinit ice wait lucid; zinit snippet OMZL::spectrum.zsh
zinit ice wait lucid; zinit snippet OMZL::theme-and-appearance.zsh

# Efficiency
zinit ice wait lucid; zinit snippet OMZP::alias-finder
zinit ice wait lucid; zinit snippet OMZP::extract
zinit ice wait lucid; zinit snippet OMZP::vi-mode
zinit ice pick"z.sh" wait lucid; zinit load rupa/z

# Completion & search
zinit light zsh-users/zsh-completions

zinit ice lucid wait='0' atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice pick"zsh-history-substring-search.zsh"
zinit light zsh-users/zsh-history-substring-search

zinit ice pick "zsh-syntax-highlighting.zsh" wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# Theme
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Development
zinit ice wait lucid; zinit snippet OMZP::git
zinit ice wait lucid; zinit snippet OMZP::colored-man-pages

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

###------------------------------------------------
### ZSH ENHANCEMENT
###------------------------------------------------
# disable Ctrl+D to close session
setopt IGNORE_EOF

# enable Ctrl+s and Ctrl+q
stty start undef
stty stop undef
setopt noflowcontrol

# zsh history
export HISTFILE=$HOME/.zhistory
export HISTSIZE=9999
export SAVEHIST=9999

# reload zsh configs globally
function zshld {
    myextdir=$(basename $(echo "${ZSH_PLUGIN_DIR}" | sed -E -n "s|(.*[^/])/?|\1|p"))
    if [ -e $ZINIT_WORKDIR ]; then
        ls -d $ZINIT_WORKDIR/snippets/* | grep "$myextdir" | xargs rm -rf
    fi
    source $HOME/.zshrc
}

# extra paths
export PATH=$HOME/.local/bin:$PATH
export RLWRAP_HOME=${HOME}/.config/rlwrap

# respect p10k theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# respect fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
