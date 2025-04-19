#!/bin/bash
# Handy shell utilities to speed up development.
# https://github.com/caesar0301/cool-dotfiles/blob/main/lib/shmisc.sh
#
# Copyright (c) 2024, Xiaming Chen
# License: MIT

LOCAL_GOROOT="$HOME/.local/go"

# Function to print colored messages
function print_message {
  local color_code=$1
  local level=$2
  shift 2
  printf "${color_code}[%s] [${level}] %s\033[0m\n" "$(date '+%Y-%m-%dT%H:%M:%S')" "$@"
}

# Colored messages
function warn {
  print_message '\033[0;33m' "WARN" "$@"
}

function info {
  print_message '\033[0;32m' "INFO" "$@"
}

function error {
  print_message '\033[0;31m' "ERROR" "$@"
  exit 1
}

# Get absolute path of current file
function abspath {
  echo "$(dirname "$(realpath "$0")")"
}

function absfilepath {
  echo "$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
}

# Create a temporary directory and set a trap to clean it up
function get_temp_dir {
  local TEMP_DIR
  TEMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TEMP_DIR"' EXIT
  echo "$TEMP_DIR"
}

# Check if a command exists
function checkcmd {
  command -v "$1" >/dev/null 2>&1
}

# Create a directory if it doesn't exist
function mkdir_nowarn {
  mkdir -p "$1"
}

# Check and assure sudo access
function check_sudo_access {
  local prompt
  prompt=$(sudo -nv 2>&1)
  if [ $? -eq 0 ]; then
    info "sudo access has been set"
  elif echo "$prompt" | grep -q '^sudo:'; then
    warn "sudo access required:"
    sudo -v
  else
    error "sudo access not granted"
  fi
}

# Generate a random UUID
function random_uuid {
  local NEW_UUID
  NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo "$NEW_UUID"
}

# Generate a random UUID with only lower-case alphanumeric characters
function random_uuid_lower {
  local NEW_UUID
  NEW_UUID=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1)
  echo "$NEW_UUID"
}

# Generate a random number
function random_num {
  local WIDTH=${1:-4}
  local NUMBER
  NUMBER=$(cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head --bytes "$WIDTH")
  echo "${NUMBER:-0}"
}

# Get the current shell name
function current_shell_name {
  local ostype
  local username
  local shellname
  ostype=$(uname -s)
  username=$(whoami)
  if [[ $ostype == "Darwin" ]]; then
    shellname=$(dscl . -read "/Users/$username" UserShell | awk '{print $2}')
  else
    shellname=$(awk -F: -v user="$username" '$1 == user {print $7}' /etc/passwd)
  fi
  echo "$(basename "$shellname")"
}

# Get the current shell configuration file
function current_shell_config {
  local sname
  local shellconfig="/dev/null"
  sname=$(current_shell_name)
  if [[ $sname == "zsh" ]]; then
    shellconfig="$HOME/.zshrc"
  elif [[ $sname == "bash" ]]; then
    shellconfig="$HOME/.bashrc"
  fi
  echo "$shellconfig"
}

# Get the latest GitHub release URL
function latest_github_release {
  local repo=$1
  local proj=$2
  local link
  link=$(curl -s "https://api.github.com/repos/$repo/$proj/releases/latest" | grep browser_download_url | cut -d '"' -f 4)
  echo "$link"
}

# Check if running on Linux
function is_linux {
  [[ $(uname -s) == "Linux" ]]
}

# Check if running on macOS
function is_macos {
  [[ $(uname -s) == "Darwin" ]]
}

# Check if running on x86 architecture
function is_x86_64 {
  local CPU_ARCH
  CPU_ARCH=$(uname -m)
  [[ "$CPU_ARCH" == "x86_64" || "$CPU_ARCH" == "i"*"86" ]]
}

# Check if running on ARM architecture
function is_arm64 {
  local CPU_ARCH
  CPU_ARCH=$(uname -m)
  [[ "$CPU_ARCH" == "arm64" || "$CPU_ARCH" == "aarch64" ]]
}

# Install pyenv to manage Python versions
function install_pyenv {
  if [ ! -e "$HOME/.pyenv" ]; then
    info "Installing pyenv to $HOME/.pyenv..."
    curl -k https://pyenv.run | bash
  fi
}

# Install jenv to manage Java versions
function install_jenv {
  if checkcmd jenv; then
    info "jenv already installed"
    return
  fi

  if is_macos; then
    brew install jenv
  elif is_linux; then
    if [ ! -e "$HOME/.jenv" ]; then
      info "Installing jenv to $HOME/.jenv..."
      git clone https://github.com/jenv/jenv.git "$HOME/.jenv"
    fi
    PATH="$HOME/.jenv/bin:$PATH"
  fi

  eval "$(jenv init -)"
}

# Install a Java decompiler (CFR)
function install_java_decompiler {
  info "Installing CFR - another Java decompiler"
  mkdir_nowarn "$HOME/.local/bin"
  local cfrfile="cfr-0.152.jar"
  local target="$HOME/.local/bin/$cfrfile"
  if [ ! -e "$target" ]; then
    curl -k -L --progress-bar "https://www.benf.org/other/cfr/$cfrfile" --output "$target"
  fi
}

# Install jdt-language-server
function install_jdt_language_server {
  info "Installing jdt-language-server to $dpath..."
  local dpath="$HOME/.local/share/jdt-language-server"
  local jdtdl="https://download.eclipse.org/jdtls/milestones/1.23.0/jdt-language-server-1.23.0-202304271346.tar.gz"
  if [ ! -e "$dpath/bin/jdtls" ]; then
    mkdir_nowarn "$dpath"
    curl -L --progress-bar "$jdtdl" | tar zxf - -C "$dpath"
  else
    info "$dpath/bin/jdtls already exists"
  fi
}

# Install google-java-format
function install_google_java_format {
  info "Installing google-java-format to $dpath..."
  local dpath="$HOME/.local/share/google-java-format"
  local fmtdl="https://github.com/google/google-java-format/releases/download/v1.17.0/google-java-format-1.17.0-all-deps.jar"
  if ! compgen -G "$dpath/google-java-format*.jar" >/dev/null; then
    curl -L --progress-bar --create-dirs "$fmtdl" -o "$dpath/google-java-format-all-deps.jar"
  else
    info "$dpath/google-java-format-all-deps.jar already installed"
  fi
}

# Install Go
function install_golang {
  info "Installing Go..."
  local godl="https://go.dev/dl"
  local gover=${1:-"1.24.2"}

  if checkcmd go; then
    info "Go binary already installed"
    return
  fi

  mkdir_nowarn "$(dirname "$LOCAL_GOROOT")"

  local GO_RELEASE
  if is_macos; then
    if is_x86_64; then
      GO_RELEASE="go${gover}.darwin-amd64"
    elif is_arm64; then
      GO_RELEASE="go${gover}.darwin-arm64"
    else
      error "Unsupported CPU architecture, exit"
    fi
  else # is_linux
    if is_x86_64; then
      GO_RELEASE="go${gover}.linux-amd64"
    elif is_arm64; then
      GO_RELEASE="go${gover}.linux-arm64"
    else
      error "Unsupported CPU architecture, exit"
    fi
  fi

  local link="${godl}/${GO_RELEASE}.tar.gz"
  info "Downloading Go from $link"
  curl -k -L --progress-bar "$link" | tar -xz -C "$(dirname "$LOCAL_GOROOT")"
}

# Install a Go library
function go_install_lib {
  local GOCMD
  if [ -e "${LOCAL_GOROOT}/bin/go" ]; then
    GOCMD="${LOCAL_GOROOT}/bin/go"
  else
    GOCMD="go"
  fi
  if checkcmd "$GOCMD"; then
    "$GOCMD" install "$1"
  else
    warn "Go not found in PATH, skip $1"
  fi
}

# Install Hack Nerd Font
function install_hack_nerd_font {
  info "Installing Hack Nerd Font and updating font cache..."
  if ! checkcmd fc-list; then
    error "Fontconfig tools (fc-list, fc-cache) not found."
  fi
  local FONTDIR="$HOME/.local/share/fonts"
  if is_macos; then
    FONTDIR="$HOME/Library/Fonts"
  fi
  if ! fc-list | grep "Hack Nerd Font" >/dev/null; then
    mkdir_nowarn "$FONTDIR"
    curl -L --progress-bar "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.tar.xz" | tar xJ -C "$FONTDIR"
    fc-cache -f
  else
    info "Hack Nerd Font already installed"
  fi
}

# Install shfmt
function install_shfmt {
  info "Installing shfmt..."
  local shfmtver=${1:-"v3.7.0"}
  local shfmtfile="shfmt_${shfmtver}_linux_amd64"
  if [ "$(uname)" == "Darwin" ]; then
    shfmtfile="shfmt_${shfmtver}_darwin_amd64"
  fi
  mkdir_nowarn "$HOME/.local/bin"
  curl -L --progress-bar "https://github.com/mvdan/sh/releases/download/${shfmtver}/$shfmtfile" -o "$HOME/.local/bin/shfmt"
  chmod +x "$HOME/.local/bin/shfmt"
}

# Install fzf
function install_fzf {
  if [ ! -e "$HOME/.fzf" ]; then
    info "Installing fzf to $HOME/.fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
  fi
  local shellconfig
  shellconfig=$(current_shell_config)
  if ! grep -r "source.*\.fzf\.zsh" "$shellconfig" >/dev/null; then
    local config='[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh'
    echo >>"$shellconfig"
    echo "# automatic configs by cool-dotfiles nvim installer" >>"$shellconfig"
    echo "$config" >>"$shellconfig"
  fi
}

# Install zsh
function install_zsh {
  info "Installing zsh..."
  if checkcmd zsh; then
    info "zsh binary already exists"
    return
  fi
  mkdir_nowarn "$HOME/.local/bin"
  mkdir_nowarn "/tmp/build-zsh"
  curl -k -L --progress-bar "http://ftp.funet.fi/pub/unix/shells/zsh/zsh-${ZSH_VERSION}.tar.xz" | tar xJ -C "/tmp/build-zsh/"
  (
    cd "/tmp/build-zsh/zsh-${ZSH_VERSION}" && ./configure --prefix "$HOME/.local" && make && make install
  )
  rm -rf "/tmp/build-zsh"
}

# Install Neovim
function install_neovim {
  info "Installing Neovim..."
  local nvimver=${1:-"0.11.0"}

  if checkcmd nvim; then
    info "Neovim binary already installed"
    return
  fi

  mkdir_nowarn "$HOME/.local"

  local NVIM_RELEASE
  if is_macos; then
    if is_x86_64; then
      NVIM_RELEASE="nvim-macos-x86_64"
    elif is_arm64; then
      NVIM_RELEASE="nvim-macos-arm64"
    else
      error "Unsupported CPU architecture, exit"
    fi
  else # is_linux
    if is_x86_64; then
      NVIM_RELEASE="nvim-linux-x86_64"
    elif is_arm64; then
      NVIM_RELEASE="nvim-linux-arm64"
    else
      error "Unsupported CPU architecture, exit"
    fi
  fi

  local link="https://github.com/neovim/neovim/releases/download/v${nvimver}/${NVIM_RELEASE}.tar.gz"
  info "Downloading Neovim from $link"
  curl -k -L --progress-bar "$link" | tar -xz --strip-components=1 -C "$HOME/.local"
}