# reload zsh configs globally
function zshld {
  myextdir=$(basename $(echo "${ZSH_PLUGIN_DIR}" | sed -E -n "s|(.*[^/])/?|\1|p"))
  if [ -e $ZINIT_WORKDIR/snippets ]; then
    ls -d $ZINIT_WORKDIR/snippets/* | grep "$myextdir" | xargs rm -rf
  fi
  source $HOME/.zshrc
}

# start or access tmux dev session
function bingo {
  if tmux info &>/dev/null; then
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
function zsh-update-plugins {
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
function nvim-update-plugins {
  nvim --headless -c "PackerClean" -c "PackerUpdate" \
    -c "TSUpdate lua python go java vim vimdoc luadoc markdown" \
    -c 'qall'
}

# Load custom extensions under $ZSH_PLUGIN_DIR
_zinit_ice_plugin() {
  plugin_name=$1
  plugin_path=${ZSH_PLUGIN_DIR}/${plugin_name}
  if [ ! -e ${plugin_path} ]; then
    return 1
  fi
  zinit ice wait lucid
  zinit light $plugin_path
}
