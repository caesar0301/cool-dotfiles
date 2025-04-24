#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname "$(realpath "$0")")
XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}

# Load common utils
source "$THISDIR/../lib/shmisc.sh"

# Function to install language formatters
function install_lang_formatters {
  info "Installing file format dependencies..."
  install_google_java_format
  install_shfmt
  if ! checkcmd yamlfmt; then
    go_install_lib github.com/google/yamlfmt/cmd/yamlfmt@latest
  fi
  # Install formatters from pip
  pip_install_lib pynvim black sqlparse cmake_format
  # Install formatters from npm
  local npmlibs=("neovim")
  if ! checkcmd luafmt; then npmlibs+=("lua-fmt"); fi
  if ! checkcmd yaml-language-server; then npmlibs+=("yaml-language-server"); fi
  if ! checkcmd js-beautify; then npmlibs+=("js-beautify"); fi
  npm_install_lib "${npmlibs[*]}"
}

# Function to install LSP dependencies
function install_lsp_deps {
  info "Installing LSP dependencies..."
  pip_install_lib pyright cmake-language-server
  rlang_install_lib "languageserver"
  go_install_lib golang.org/x/tools/gopls@latest
  go_install_lib github.com/jstemmer/gotags@latest
}

# Function to check if ripgrep is installed
function check_ripgrep {
  if ! checkcmd rg; then
    warn "ripgrep not found, as required by telescope.nvim"
  fi
}

# Function to handle ctags configuration
function handle_ctags {
  local ctags_home="$HOME/.ctags.d"
  create_dir "$ctags_home"
  if [ -e "$ctags_home" ]; then
    for i in $(find "$THISDIR/../ctags" -maxdepth 1 -type f -name "*.ctags"); do
      install_file_pairs "$i" "$ctags_home/"
    done
  fi
}

# Function to handle Neovim installation and configuration
function handle_neovim {
  # Install plugin manager
  local packer_home="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
  if [ ! -e "$packer_home" ]; then
    info "Installing plugin manager Packer..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packer_home"
  fi
  install_file_pairs "$THISDIR" "$XDG_CONFIG_HOME/"
}

function post_install {
  warn "**********Post installation*************"
  warn "Run following commands in Neovim to install plugins:"
  warn ":PackerInstall"
  warn ":TSUpdate lua python go java vim vimdoc luadoc markdown"
  warn "****************************************"
}

# Function to cleanse all Neovim-related files
function cleanse_all {
  rm -rf "$HOME/.ctags"
  rm -rf "$XDG_CONFIG_HOME/nvim"
  rm -rf "$XDG_DATA_HOME/nvim/site/pack"
  info "All Neovim files cleansed!"
}

# Function to display usage information
function usage {
  echo "Usage: install.sh [-f] [-s] [-e] [-c]"
  echo "  -f copy and install"
  echo "  -s soft link install"
  echo "  -e install dependencies"
  echo "  -c cleanse install"
}

# Change to 0 to install a copy instead of soft link
LINK_INSTEAD_OF_COPY=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) LINK_INSTEAD_OF_COPY=0 ;;
  s) LINK_INSTEAD_OF_COPY=1 ;;
  e) WITHDEPS=1 ;;
  c) cleanse_all && exit 0 ;;
  h | ?) usage && exit 0 ;;
  esac
done

if [ "x$WITHDEPS" == "x1" ]; then
  install_neovim
  install_lsp_deps
  install_jdt_language_server
  install_hack_nerd_font # Required by nvim-web-devicons
  install_lang_formatters
  install_fzf
  check_ripgrep
fi

handle_ctags
handle_neovim
post_install

info "Success! Run :PackerInstall to install Neovim plugins"
