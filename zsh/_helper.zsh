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

# Function to add to PATH if the directory exists
add_to_path() {
  local dir=$1
  if [ -d "$dir" ]; then
    export PATH="$dir:$PATH"
  fi
}

# reload zsh configs globally
function zshld {
    myextdir=$(basename $(echo "${ZSH_PLUGIN_DIR}" | sed -E -n "s|(.*[^/])/?|\1|p"))
    if [ -e $ZINIT_WORKDIR/snippets ]; then
        ls -d $ZINIT_WORKDIR/snippets/* | grep "$myextdir" | xargs rm -rf
    fi
    source $HOME/.zshrc
}