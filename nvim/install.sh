#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

PYPI_OPTIONS="-i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com"
NPM_OPTIONS="--prefer-offline --no-audit --progress=false"

# load common utils
source $THISDIR/../lib/shmisc.sh

# Formatting dependencies
function install_lang_formatters {
  info "Installing file format dependencies..."

  install_google_java_format

  if ! checkcmd shfmt; then
    install_shfmt
  fi

  if ! checkcmd yamlfmt; then
    go_install_lib github.com/google/yamlfmt/cmd/yamlfmt@latest
  fi

  # formatters on pip
  piplibs=(pynvim black sqlparse cmake_format)
  if checkcmd pip; then
    if [[ ${#piplibs[@]} > 0 ]]; then
      info "Installing pip deps: $piplibs"
      pip install ${PYPI_OPTIONS} -q -U ${piplibs[@]}
    fi
  else
    warn "Command pip not found, install and try again."
  fi

  # formatters on npm
  npmlibs=(neovim)
  if ! checkcmd luafmt; then npmlibs+=(lua-fmt); fi
  if ! checkcmd yaml-language-server; then npmlibs+=(yaml-language-server); fi
  if ! checkcmd js-beautify; then npmlibs+=(js-beautify); fi
  if checkcmd npm; then
    if [[ ${#npmlibs[@]} > 0 ]]; then
      info "Installing npm deps: $npmlibs"
      npm config set registry https://registry.npmmirror.com
      if [ "x${SUDO_PASS}" == "x" ]; then
        sudo npm install ${NPM_OPTIONS} -g ${npmlibs[@]}
      else
        echo "${SUDO_PASS}" | sudo -S npm install ${NPM_OPTIONS} -g ${npmlibs[@]}
      fi
    fi
  else
    warn "Command npm not found, install and try again."
  fi
}

function install_lsp_deps {
  info "Install LSP dependencies..."

  piplibs=(pyright cmake-language-server)
  if checkcmd pip; then
    if [[ ${#piplibs[@]} > 0 ]]; then
      info "Installing pip deps: $piplibs"
      pip install ${PYPI_OPTIONS} -q -U ${piplibs[@]}
    fi
  else
    warn "Command pip not found, install and try again."
  fi

  info "Install R language server..."
  if checkcmd R; then
    if ! $(R -e "library(languageserver)" >/dev/null); then
      R -e "install.packages('languageserver', repos='https://mirrors.nju.edu.cn/CRAN/')"
    fi
  fi

  go_install_lib golang.org/x/tools/gopls@latest
  go_install_lib github.com/jstemmer/gotags@latest
}

function check_ripgrep {
  if ! checkcmd rg; then
    warn "ripgrep not found, as required by telescope.nvim"
  fi
}

function handle_ctags {
  local ctags_home=$HOME/.ctags.d
  mkdir_nowarn $ctags_home
  if [ -e ${ctags_home} ]; then
    for i in $(find $THISDIR/../ctags -maxdepth 1 -type f -name "*.ctags"); do
      if [ x$SOFTLINK == "x1" ]; then
        ln -sf $i $ctags_home/
      else
        cp $i $ctags_home/
      fi
    done
  fi
}

function handle_neovim {
  # install plugin manager
  packer_home=$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
  if [ ! -e ${packer_home} ]; then
    info "Install plugin manager Packer..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  fi
  if [ x$SOFTLINK == "x1" ]; then
    ln -sf $THISDIR $XDG_CONFIG_HOME/
  else
    cp -r $THISDIR $XDG_CONFIG_HOME/
  fi
}

function install_all_deps {
  install_lsp_deps
  install_jdt_language_server
  install_hack_nerd_font # required by nvim-web-devicons
  install_lang_formatters
  install_fzf
  check_ripgrep
}

function post_install {
  info "Post installation"
  nvim --headless \
    -c "PackerInstall" \
    -c "TSUpdate lua python go java vim vimdoc luadoc markdown" \
    -c "qall"
  echo ""
}

function cleanse_all {
  rm -rf $HOME/.ctags
  rm -rf $XDG_CONFIG_HOME/nvim
  rm -rf $XDG_DATA_HOME/nvim/site/pack
  info "All nvim cleansed!"
}

function usage {
  echo "Usage: install.sh [-f] [-s] [-e]"
  echo "  -f copy and install"
  echo "  -s soft linke install"
  echo "  -e install dependencies"
  echo "  -c cleanse install"
}

# Change to 0 to install a copy instead of soft link
SOFTLINK=1
WITHDEPS=1
while getopts fsech opt; do
  case $opt in
  f) SOFTLINK=0 ;;
  s) SOFTLINK=1 ;;
  e) WITHDEPS=1 ;;
  c) cleanse_all && exit 0 ;;
  h | ?) usage && exit 0 ;;
  esac
done

if [ "x$WITHDEPS" == "x1" ]; then
  install_neovim
  install_golang
  install_all_deps
fi

handle_ctags
handle_neovim
post_install

info "Successed! Run :PackerInstall to install nvim plugins"
