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
