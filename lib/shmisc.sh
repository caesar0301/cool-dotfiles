#!/bin/bash
# Handy shell utilities to speed up development.
# https://github.com/caesar0301/cool-dotfiles/blob/main/lib/shmisc.sh
#
# Copyright (c) 2024, Xiaming Chen
# License: MIT

# Print colored messages
print_message() {
  local color_code=$1
  local level=$2
  shift 2
  printf "${color_code}[%s] [${level}] %s\033[0m\n" "$(date '+%Y-%m-%dT%H:%M:%S')" "$@"
}

# Colored messages
warn() {
  print_message '\033[0;33m' "WARN" "$@"
}

info() {
  print_message '\033[0;32m' "INFO" "$@"
}

error() {
  print_message '\033[0;31m' "ERROR" "$@"
  exit 1
}

# Get absolute path of current file
abspath() {
  echo "$(dirname "$(realpath "$0")")"
}

absfilepath() {
  echo "$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
}

# Function to create directories
create_dir() {
  local dir=$1
  if [ ! -d "$dir" ]; then
    create_dir "$dir"
  fi
}

# Create a temporary directory and set a trap to clean it up
get_temp_dir() {
  local TEMP_DIR
  TEMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TEMP_DIR"' EXIT
  echo "$TEMP_DIR"
}

# Check if a command exists
checkcmd() {
  command -v "$1" >/dev/null 2>&1
}

# Check and assure sudo access
check_sudo_access() {
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
random_uuid() {
  local NEW_UUID
  NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo "$NEW_UUID"
}

# Generate a random UUID with only lower-case alphanumeric characters
random_uuid_lower() {
  local NEW_UUID
  NEW_UUID=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1)
  echo "$NEW_UUID"
}

# Generate a random number
random_num() {
  local WIDTH=${1:-4}
  local NUMBER
  NUMBER=$(cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head --bytes "$WIDTH")
  echo "${NUMBER:-0}"
}

# Get the current shell name
current_shell_name() {
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
current_shell_config() {
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
latest_github_release() {
  local repo=$1
  local proj=$2
  local link
  link=$(curl -s "https://api.github.com/repos/$repo/$proj/releases/latest" | grep browser_download_url | cut -d '"' -f 4)
  echo "$link"
}

# Check if running on Linux
is_linux() {
  [[ $(uname -s) == "Linux" ]]
}

# Check if running on macOS
is_macos() {
  [[ $(uname -s) == "Darwin" ]]
}

# Check if running on x86 architecture
is_x86_64() {
  local CPU_ARCH
  CPU_ARCH=$(uname -m)
  [[ "$CPU_ARCH" == "x86_64" || "$CPU_ARCH" == "i"*"86" ]]
}

# Check if running on ARM architecture
is_arm64() {
  local CPU_ARCH
  CPU_ARCH=$(uname -m)
  [[ "$CPU_ARCH" == "arm64" || "$CPU_ARCH" == "aarch64" ]]
}

# Install pyenv to manage Python versions
install_pyenv() {
  if [ ! -e "$HOME/.pyenv" ]; then
    info "Installing pyenv to $HOME/.pyenv..."
    curl -k https://pyenv.run | bash
  fi
}

# Install jenv to manage Java versions
install_jenv() {
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
install_java_decompiler() {
  info "Installing CFR - another Java decompiler"
  create_dir "$HOME/.local/bin"
  local cfrfile="cfr-0.152.jar"
  local target="$HOME/.local/bin/$cfrfile"
  if [ ! -e "$target" ]; then
    curl -k -L --progress-bar "https://www.benf.org/other/cfr/$cfrfile" --output "$target"
  fi
}

# Install jdt-language-server
install_jdt_language_server() {
  info "Installing jdt-language-server to $dpath..."
  local dpath="$HOME/.local/share/jdt-language-server"
  local jdtdl="https://download.eclipse.org/jdtls/milestones/1.23.0/jdt-language-server-1.23.0-202304271346.tar.gz"
  if [ ! -e "$dpath/bin/jdtls" ]; then
    create_dir "$dpath"
    curl -L --progress-bar "$jdtdl" | tar zxf - -C "$dpath"
  else
    info "$dpath/bin/jdtls already exists"
  fi
}

# Install google-java-format
install_google_java_format() {
  info "Installing google-java-format to $dpath..."
  local dpath="$HOME/.local/share/google-java-format"
  local fmtdl="https://github.com/google/google-java-format/releases/download/v1.17.0/google-java-format-1.17.0-all-deps.jar"
  if ! compgen -G "$dpath/google-java-format*.jar" >/dev/null; then
    curl -L --progress-bar --create-dirs "$fmtdl" -o "$dpath/google-java-format-all-deps.jar"
  else
    info "$dpath/google-java-format-all-deps.jar already installed"
  fi
}

# Install go version manager
install_gvm() {
  if checkcmd gvm; then
    info "gvm already installed"
    return
  fi

  if [ -e "$HOME/.gvm" ]; then
    warn "$HOME/.gvm alreay exists, skip"
    return
  fi

  info "Installing GVM..."
  bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
  if [ $? -ne 0 ]; then
    error "GVM installation failed."
    return
  fi

  # Detect shell and configure profile
  SHELL_TYPE=$(basename "$SHELL")
  case "$SHELL_TYPE" in
  bash) PROFILE_FILE="$HOME/.bash_profile" ;;
  zsh) PROFILE_FILE="$HOME/.zshrc" ;;
  *) PROFILE_FILE="$HOME/.profile" ;;
  esac

  # Add GVM to shell profile if not already present
  GVM_LINE='[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"'
  if ! grep -Fx "$GVM_LINE" "$PROFILE_FILE" >/dev/null 2>&1; then
    info "Adding GVM to $PROFILE_FILE..."
    echo "$GVM_LINE" >>"$PROFILE_FILE"
  fi

  # Source GVM in current session
  source "$HOME/.gvm/scripts/gvm"

  # Verify GVM installation
  if command -v gvm >/dev/null 2>&1; then
    info "GVM installed successfully. Version: $(gvm version)"
  else
    error "GVM installation failed. Please check logs above."
    return
  fi

  # Install Go 1.24.2 to resolve version mismatch
  info "Installing Go 1.24.2 (binary) as default..."
  gvm install go1.24.2 -B
  if [ $? -eq 0 ]; then
    gvm use go1.24.2 --default
    info "Go 1.24.2 set as default. Verify with: go version"
  else
    error "Failed to install Go 1.24.2. Please check GVM setup."
    return
  fi

  info "GVM setup complete!"
}

# Install Go
install_golang() {
  if checkcmd go; then
    return
  fi

  info "Installing Go..."
  local godl="https://go.dev/dl"
  local gover=${1:-"1.24.2"}
  local custom_goroot="$HOME/.local/go"

  create_dir "$(dirname "$custom_goroot")"

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
  curl -k -L --progress-bar "$link" | tar -xz -C "$(dirname "$custom_goroot")"
}

# Install a Go library
go_install_lib() {
  local gocmd="go"
  local lib=$1
  local custom_goroot="$HOME/.local/go"

  if ! checkcmd "$gocmd"; then
    if [ -e "${custom_goroot}/bin/go" ]; then
      gocmd="${custom_goroot}/bin/go"
      info "Using custom Go installation at $gocmd"
    else
      warn "Go not found in PATH, skip installing $lib"
      return
    fi
  fi

  "$gocmd" install "$lib"
}

# Install a pip library
pip_install_lib() {
  local libs=("$@") # Accept multiple arguments as an array
  local options="--index-url http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com"
  local pip_cmd="pip"

  # Check if pip is available
  if ! command -v "$pip_cmd" &>/dev/null; then
    warn "pip not found in PATH, skipping installation of ${libs[*]}"
    return
  fi

  # Check if any libraries are provided
  if [[ ${#libs[@]} -eq 0 ]]; then
    warn "No libraries specified for installation"
    return
  fi

  info "Installing pip libraries: ${libs[*]}"
  # Install all libraries in one pip command, with upgrade and quiet flags
  "$pip_cmd" install $options -q -U "${libs[@]}" || {
    warn "Failed to install one or more libraries: ${libs[*]}"
    return
  }
}

# Install one or more npm libraries globally
npm_install_lib() {
  local libs=("$@") # Capture all arguments as an array
  local options="--prefer-offline --no-audit --progress=false"
  local npm_cmd="npm"
  local registry="https://registry.npmmirror.com"

  # Check if npm is available
  if ! command -v "$npm_cmd" >/dev/null 2>&1; then
    warn "npm not found in PATH, skipping installation of ${libs[*]}"
    return
  fi

  # Validate input
  if [ ${#libs[@]} -eq 0 ]; then
    warn "No libraries specified for installation"
    return
  fi

  info "Installing npm libraries: ${libs[*]}"
  # Set npm registry
  "$npm_cmd" config set registry "$registry"

  # Install libraries with or without sudo
  if [ -z "$SUDO_PASS" ]; then
    sudo "$npm_cmd" install $options -g "${libs[@]}"
  else
    echo "$SUDO_PASS" | sudo -S "$npm_cmd" install $options -g "${libs[@]}"
  fi
}

# Install a R library
rlang_install_lib() {
  local lib=$1
  if checkcmd R; then
    if ! R -e "library(${lib})" >/dev/null 2>&1; then
      R -e "install.packages('${lib}', repos='https://mirrors.nju.edu.cn/CRAN/')"
    fi
  else
    warn "R not found in PATH, skip installing $lib"
  fi
}

# Install Hack Nerd Font
install_hack_nerd_font() {
  info "Installing Hack Nerd Font and updating font cache..."
  if ! checkcmd fc-list; then
    warn "Fontconfig tools (fc-list, fc-cache) not found."
    return
  fi
  local FONTDIR="$HOME/.local/share/fonts"
  if is_macos; then
    FONTDIR="$HOME/Library/Fonts"
  fi
  if ! fc-list | grep "Hack Nerd Font" >/dev/null; then
    create_dir "$FONTDIR"
    curl -L --progress-bar "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.tar.xz" | tar xJ -C "$FONTDIR"
    fc-cache -f
  else
    info "Hack Nerd Font already installed"
  fi
}

# Install shfmt
install_shfmt() {
  if checkcmd shfmt; then
    return
  fi
  info "Installing shfmt..."
  local shfmtver=${1:-"v3.7.0"}
  local shfmtfile="shfmt_${shfmtver}_linux_amd64"
  if [ "$(uname)" == "Darwin" ]; then
    shfmtfile="shfmt_${shfmtver}_darwin_amd64"
  fi
  create_dir "$HOME/.local/bin"
  curl -L --progress-bar "https://github.com/mvdan/sh/releases/download/${shfmtver}/$shfmtfile" -o "$HOME/.local/bin/shfmt"
  chmod +x "$HOME/.local/bin/shfmt"
}

# Install fzf
install_fzf() {
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
install_zsh() {
  if checkcmd zsh; then
    return
  fi
  info "Installing zsh..."
  create_dir "$HOME/.local/bin"
  create_dir "/tmp/build-zsh"
  curl -k -L --progress-bar "http://ftp.funet.fi/pub/unix/shells/zsh/zsh-${ZSH_VERSION}.tar.xz" | tar xJ -C "/tmp/build-zsh/"
  (
    cd "/tmp/build-zsh/zsh-${ZSH_VERSION}" && ./configure --prefix "$HOME/.local" && make && make install
  )
  rm -rf "/tmp/build-zsh"
}

# Install Neovim
install_neovim() {
  if checkcmd nvim; then
    return
  fi

  info "Installing Neovim..."
  local nvimver=${1:-"0.11.0"}
  create_dir "$HOME/.local"

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
