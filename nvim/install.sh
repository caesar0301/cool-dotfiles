#!/bin/bash
###################################################
# Install script for
# https://github.com/caesar0301/cool-dotfiles
# Maintainer: xiaming.chen
###################################################
THISDIR=$(dirname $(realpath $0))
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

SHFMT_VERSION="v3.7.0"
GOPROXY="https://mirrors.aliyun.com/goproxy/,direct"
PYPI_OPTIONS="-i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com"
NPM_OPTIONS="--prefer-offline --no-audit --progress=false"

# load common utils
source $THISDIR/../lib/shmisc.sh

function install_neovim {
  info "Installing neovim..."
  if ! checkcmd nvim; then
    mkdir_nowarn $HOME/.local
    link="https://github.com/neovim/neovim-releases/releases/latest/download/nvim-linux-x86_64.tar.gz"
    curl -k -L --progress-bar $link | tar zxf --strip-components=1 -C $HOME/.local
  else
    info "neovim binary already installed"
  fi
}

function install_hack_nerd_font {
  info "Install Hack nerd font and update font cache..."
  if ! checkcmd fc-list; then
    error "fontconfig tools (fc-list, fc-cache) not found."
    exit 1
  fi
  FONTDIR=$HOME/.local/share/fonts
  if [ "$(uname)" == "Darwin" ]; then
    FONTDIR=$HOME/Library/Fonts
  fi
  # install nerd patched font Hack, required by nvim-web-devicons
  if ! $(fc-list | grep "Hack Nerd Font" >/dev/null); then
    mkdir_nowarn $FONTDIR
    curl -L --progress-bar https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.tar.xz | tar xJ -C $FONTDIR
    fc-cache -f
  else
    info "Hack Nerd Font already installed"
  fi
}

# Required by nvim-jdtls
function install_jdt_language_server {
  info "Installing jdt-language-server to $dpath..."
  jdtlink="https://download.eclipse.org/jdtls/milestones/1.23.0/jdt-language-server-1.23.0-202304271346.tar.gz"
  dpath=$HOME/.local/share/jdt-language-server
  if [ ! -e $dpath/bin/jdtls ]; then
    mkdir_nowarn $dpath >/dev/null
    curl -L --progress-bar $jdtlink | tar zxf - -C $dpath
  else
    info "$dpath/bin/jdtls already exists"
  fi
}

function install_google_java_format {
  info "Installing google-java-format to $dpath..."
  rfile="https://github.com/google/google-java-format/releases/download/v1.17.0/google-java-format-1.17.0-all-deps.jar"
  dpath=$HOME/.local/share/google-java-format
  if ! compgen -G "$dpath/google-java-format*.jar" >/dev/null; then
    curl -L --progress-bar --create-dirs $rfile -o $dpath/google-java-format-all-deps.jar
  else
    info "$dpath/google-java-format-all-deps.jar already installed"
  fi
}

function install_shfmt {
  info "Installing shfmt..."
  shfmtfile="shfmt_${SHFMT_VERSION}_linux_amd64"
  if [ "$(uname)" == "Darwin" ]; then
    shfmtfile="shfmt_${SHFMT_VERSION}_darwin_amd64"
  fi
  mkdir_nowarn $HOME/.local/bin
  curl -L --progress-bar https://github.com/mvdan/sh/releases/download/${SHFMT_VERSION}/$shfmtfile -o $HOME/.local/bin/shfmt
  chmod +x $HOME/.local/bin/shfmt
}

function go_install_lib {
  checkcmd go && go install "$1" || warn "Go not found in PATH, skip $1"
}

function install_yamlfmt {
  info "Installing yamlfmt..."
  go_install_lib github.com/google/yamlfmt/cmd/yamlfmt@latest
}

# Formatting dependencies
function install_formatter_utils {
  info "Installing file format dependencies..."

  install_google_java_format
  if ! checkcmd shfmt; then install_shfmt; fi
  if ! checkcmd yamlfmt; then install_yamlfmt; fi

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

  info "Install gopls..."
  go_install_lib golang.org/x/tools/gopls@latest
}

function install_fzf {
  if [ ! -e $HOME/.fzf ]; then
    info "Installing fzf to $HOME/.fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install --all
  fi
  shellconfig=$(current_shell_config)
  if ! grep -r "source.*\.fzf\.zsh" $shellconfig >/dev/null; then
    local config='[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh'
    echo >>$shellconfig
    echo "# automatic configs by cool-dotfiles nvim installer" >>$shellconfig
    echo $config >>$shellconfig
  fi
}

function check_ripgrep {
  if ! checkcmd rg; then
    warn "ripgrep not found, as required by telescope.nvim"
  fi
}

function install_ctags_and_deps {
  if ! checkcmd ctags; then
    warn "Command ctags not found in PATH. Please install universal-ctags from https://github.com/universal-ctags/ctags"
  fi
  # gotags
  go_install_lib github.com/jstemmer/gotags@latest
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
  install_formatter_utils
  install_fzf
  install_ctags_and_deps
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
  install_all_deps
fi

handle_ctags
handle_neovim
post_install

info "Successed! Run :PackerInstall to install nvim plugins"
