#!/bin/bash
# Handy shell utilities to speed up development.
# https://github.com/caesar0301/cool-dotfiles/blob/main/lib/shmisc.sh
#
# Copyright (c) 2024, Xiaming Chen
# License: MIT

LOCAL_GOROOT=$HOME/.local/go

# colored messages
function warn {
  YELLOW='\033[0;33m'
  NC='\033[0m' # No Color
  printf "${YELLOW}[%s] [WARN] %s${NC}\n" "$(date '+%Y-%m-%dT%H:%M:%S')" "$@"
}

function info {
  GREEN='\033[0;32m'
  NC='\033[0m' # No Color
  printf "${GREEN}[%s] [INFO] %s${NC}\n" "$(date '+%Y-%m-%dT%H:%M:%S')" "$@"
}

function error {
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  printf "${RED}[%s] [ERROR] %s${NC}\n" "$(date '+%Y-%m-%dT%H:%M:%S')" "$@"
}

# get absolute path of current file
function abspath {
  echo $(dirname $(realpath $0))
}

function absfilepath {
  echo $(cd ${0%/*} && echo $PWD/${0##*/})
}

# make trapped temp dir
function get_temp_dir {
  TEMP_DIR="$(mktemp -d)"
  trap 'rm -rf ${TEMP_DIR}' EXIT
  echo ${TEMP_DIR}
}

# check command existence
function checkcmd {
  command -v $1 1>/dev/null 2>&1
  return $?
}

# make dir if not existed
function mkdir_nowarn {
  if [ ! -e $1 ]; then mkdir -p $1; fi
}

# check and assure sudo access
function check_sudo_access {
  prompt=$(sudo -nv 2>&1)
  if [ $? -eq 0 ]; then
    info "sudo access has been set"
  elif echo $prompt | grep -q '^sudo:'; then
    warn "sudo access required:"
    sudo -v
  else
    error "sudo access not granted" && exit 1
  fi
}

# random uuid
function random_uuid {
  NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo ${NEW_UUID}
}

# random uuid with only lower-case alphanumeric chars.
function random_uuid_lower {
  NEW_UUID=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1)
  echo ${NEW_UUID}
}

# random number
function random_num {
  WIDTH=${0:-4}
  NUMBER=$(cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head --bytes ${WIDTH})
  if [ "$NUMBER" == "" ]; then
    NUMBER=0
  fi
  echo ${NUMBER}
}

# Get current shell name
function current_shell_name {
  #shellname=$(ps -hp $$ | awk '{print $5}')
  local ostype=$(uname -s)
  local username=$(whoami)
  if [[ $ostype == "Darwin" ]]; then
    shellname=$(dscl . -read /Users/$username UserShell | awk '{print $2}')
  else
    shellname=$(awk -F: -v user="$username" '$1 == user {print $7}' /etc/passwd)
  fi
  echo $(basename $shellname)
}

# Get current shell config
function current_shell_config {
  sname=$(current_shell_name)
  shellconfig="/dev/null"
  if [[ x$sname == "xzsh" ]]; then
    shellconfig="$HOME/.zshrc"
  elif [[ x$sname == "xbash" ]]; then
    shellconfig="$HOME/.bashrc"
  fi
  echo $shellconfig
}

# Get latest github release
function latest_github_release {
  local repo=$1
  local proj=$2
  link=$(curl -s https://api.github.com/repos/$repo/$proj/releases/latest | grep browser_download_url | cut -d '"' -f 4)
  echo $link
}

# Check if running on Linux
function is_linux {
  if [[ $(uname -s) == "Linux" ]]; then
    return 0
  else
    return 1
  fi
}

# Check if running on macOS
function is_macos {
  if [[ $(uname -s) == "Darwin" ]]; then
    return 0
  else
    return 1
  fi
}

# check if running on x86
function is_x86_64 {
  CPU_ARCH=$(uname -m)
  if [[ "$CPU_ARCH" == "x86_64" ]] || [[ "$CPU_ARCH" == "i"*"86" ]]; then
    return 0
  else
    return 1
  fi
}

# Check if running on ARM
function is_arm64 {
  CPU_ARCH=$(uname -m)
  if [[ "$CPU_ARCH" == "arm64" ]] || [[ "$CPU_ARCH" == "aarch64" ]]; then
    return 0
  else
    return 1
  fi
}

# Install pyenv to manage python versions
function install_pyenv {
  if [ ! -e $HOME/.pyenv ]; then
    info "Installing pyenv to $HOME/.pyenv..."
    curl -k https://pyenv.run | bash
  fi
}

# Install jenv to manage java versions
function install_jenv {
  if checkcmd jenv; then
    info "jenv already installed"
    return
  fi

  if is_macos; then
    brew install jenv
  elif is_linux; then
    if [ ! -e $HOME/.jenv ]; then
      info "Installing jenv to $HOME/.jenv..."
      git clone https://github.com/jenv/jenv.git $HOME/.jenv
    fi
    PATH="$HOME/.jenv/bin:$PATH"
  fi

  eval "$(jenv init -)"
  #eval "$(jenv enable-plugin export)"
}

# Install java decompiler
function install_java_decompiler {
  info "Installing CFR - another java decompiler"
  mkdir_nowarn $HOME/.local/bin
  local cfrfile=cfr-0.152.jar
  target="$HOME/.local/bin/$cfrfile"
  if [ ! -e $target ]; then
    curl -k -L --progress-bar https://www.benf.org/other/cfr/$cfrfile --output $target
  fi
}

function install_jdt_language_server {
  info "Installing jdt-language-server to $dpath..."
  dpath=$HOME/.local/share/jdt-language-server
  jdtdl="https://download.eclipse.org/jdtls/milestones/1.23.0/jdt-language-server-1.23.0-202304271346.tar.gz"
  if [ ! -e $dpath/bin/jdtls ]; then
    mkdir_nowarn $dpath >/dev/null
    curl -L --progress-bar $jdtdl | tar zxf - -C $dpath
  else
    info "$dpath/bin/jdtls already exists"
  fi
}

function install_google_java_format {
  info "Installing google-java-format to $dpath..."
  dpath=$HOME/.local/share/google-java-format
  fmtdl="https://github.com/google/google-java-format/releases/download/v1.17.0/google-java-format-1.17.0-all-deps.jar"
  if ! compgen -G "$dpath/google-java-format*.jar" >/dev/null; then
    curl -L --progress-bar --create-dirs $fmtdl -o $dpath/google-java-format-all-deps.jar
  else
    info "$dpath/google-java-format-all-deps.jar already installed"
  fi
}

function install_golang {
  info "Installing golang..."
  local godl="https://go.dev/dl"
  local gover=${1:-"1.24.2"}

  if checkcmd go; then
    info "go binary already installed"
    return
  fi

  mkdir_nowarn $(dirname $LOCAL_GOROOT)

  if is_macos; then
    if is_x86_64; then
      GO_RELEASE="go${gover}.darwin-amd64"
    elif is_arm64; then
      GO_RELEASE="go${gover}.darwin-arm64"
    else
      error "Unsupported CPU architecture, exit"
      exit 1
    fi
  else # is_linux
    if is_x86_64; then
      GO_RELEASE="go${gover}.linux-amd64"
    elif is_arm64; then
      GO_RELEASE="go${gover}.linux-arm64"
    else
      error "Unsupported CPU architecture, exit"
      exit 1
    fi
  fi

  link="${godl}/${GO_RELEASE}.tar.gz"
  info "Downloading go from $link"
  curl -k -L --progress-bar $link | tar -xz -C $(dirname $LOCAL_GOROOT)
}

function go_install_lib {
  if [ -e ${LOCAL_GOROOT}/bin/go ]; then
    GOCMD=${LOCAL_GOROOT}/bin/go
  else
    GOCMD=go
  fi
  checkcmd $GOCMD && $GOCMD install "$1" || warn "Go not found in PATH, skip $1"
}

function install_hack_nerd_font {
  info "Install Hack nerd font and update font cache..."
  if ! checkcmd fc-list; then
    error "fontconfig tools (fc-list, fc-cache) not found."
    exit 1
  fi
  FONTDIR=$HOME/.local/share/fonts
  if is_macos; then
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

function install_shfmt {
  info "Installing shfmt..."
  local shfmtver=${1:-"v3.7.0"}
  shfmtfile="shfmt_${shfmtver}_linux_amd64"
  if [ "$(uname)" == "Darwin" ]; then
    shfmtfile="shfmt_${shfmtver}_darwin_amd64"
  fi
  mkdir_nowarn $HOME/.local/bin
  curl -L --progress-bar https://github.com/mvdan/sh/releases/download/${shfmtver}/$shfmtfile -o $HOME/.local/bin/shfmt
  chmod +x $HOME/.local/bin/shfmt
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

function install_zsh {
  info "Installing zsh..."
  if checkcmd zsh; then
    info "zsh binary already exists"
    return
  fi
  mkdir_nowarn $HOME/.local/bin
  mkdir_nowarn /tmp/build-zsh
  curl -k -L --progress-bar http://ftp.funet.fi/pub/unix/shells/zsh/zsh-${ZSH_VERSION}.tar.xz | tar xJ -C /tmp/build-zsh/
  cd /tmp/build-zsh/zsh-${ZSH_VERSION} && ./configure --prefix $HOME/.local && make && make install && cd -
  rm -rf /tmp/build-zsh
}

function install_neovim {
  info "Installing neovim..."
  local nvimver=${1:-"0.11.0"}

  if checkcmd nvim; then
    info "neovim binary already installed"
    return
  fi

  mkdir_nowarn $HOME/.local

  if is_macos; then
    if is_x86_64; then
      NVIM_RELEASE="nvim-macos-x86_64"
    elif is_arm64; then
      NVIM_RELEASE="nvim-macos-arm64"
    else
      error "Unsupported CPU architecture, exit"
      exit 1
    fi
  else # is_linux
    if is_x86_64; then
      NVIM_RELEASE="nvim-linux-x86_64"
    elif is_arm64; then
      NVIM_RELEASE="nvim-linux-arm64"
    else
      error "Unsupported CPU architecture, exit"
      exit 1
    fi
  fi

  link="https://github.com/neovim/neovim/releases/download/v${nvimver}/${NVIM_RELEASE}.tar.gz"
  info "Downloading neovim from $link"
  curl -k -L --progress-bar $link | tar -xz --strip-components=1 -C $HOME/.local
}
