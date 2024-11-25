# skim shortcut
alias skim="/Applications/Skim.app/Contents/MacOS/Skim"

# macports
if command -v port &>/dev/null; then
  local MACPORTS_INSTALL_DIR="/opt/local"
  export PATH="${MACPORTS_INSTALL_DIR}/bin:${MACPORTS_INSTALL_DIR}/sbin:$PATH"
  export C_INCLUDE_PATH="${MACPORTS_INSTALL_DIR}/include:$C_INCLUDE_PATH"
  export LIBRARY_PATH="${MACPORTS_INSTALL_DIR}/lib:$LIBRARY_PATH"
  export LD_LIBRARY_PATH="${MACPORTS_INSTALL_DIR}/lib:$LD_LIBRARY_PATH"
fi

# homebrew
if command -v brew &>/dev/null; then
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"

  local HOMEBREW_INSTALL_DIR=$(brew --prefix)
  export PATH="${HOMEBREW_INSTALL_DIR}/bin:${HOMEBREW_INSTALL_DIR}/sbin:$PATH"
  export C_INCLUDE_PATH="${HOMEBREW_INSTALL_DIR}/include:$C_INCLUDE_PATH"
  export LIBRARY_PATH="${HOMEBREW_INSTALL_DIR}/lib:$LIBRARY_PATH"
  export LD_LIBRARY_PATH="${HOMEBREW_INSTALL_DIR}/lib:$LD_LIBRARY_PATH"
fi
