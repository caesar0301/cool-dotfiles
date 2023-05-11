#############################################################
## My custom zsh plugin for project InnoTrek
#############################################################

# Prune all docker junk data
function docker_prune_all {
    yes y | docker container prune
    yes y | docker image prune
    yes y | docker volume prune
}

# Remove deleted file from git cache
function gitrmdeleted {
    FILES=$(git ls-files -d)
    if [[ ! -z $FILES ]]; then
        git rm $FILES
    else
        echo "No deleted files"
    fi
}

# Remove git submodule
function gitrmsubmod {
    SUBMODULE=$1
    git submodule deinit -f -- $SUBMODULE
    rm -rf .git/modules/$SUBMODULE
    git rm -f $SUBMODULE
}

# Docker image tag generator
function genimgver {
    TAG="${1:-notag}"
    MODE="${2:-release}"
    echo ${MODE}_$(date +"%Y%m%d%H%M%S")_${TAG}_$(git rev-parse HEAD | head -c 8)
}

# Proxy triggers
function enable_proxy {
    export OLD_PROMPT="$PROMPT"
    HHOST="${PROXY_HTTP_HOST:-127.0.0.1}"
    HPORT="${PROXY_HTTP_PORT:-6152}"
    SPORT="${PROXY_SOCKS_PORT:-6153}"
    if [[ $(uname -r) =~ "microsoft-standard" ]]; then
        PROXYH=$(/mnt/c/Windows/system32/ipconfig.exe /all |
            sed -n -E "s|.*IPv4 Address.*([0-9]{3}(\.[0-9]*){3})\(Preferred\)|\1|p" |
            grep 192.168.0 |
            tr -d '\r\n\t[:blank:]')
    fi
    export http_proxy="http://${HHOST}:${HPORT}" \
        https_proxy="http://${HHOST}:${HPORT}" \
        all_proxy="socks5://${HHOST}:${SPORT}"
    export PROMPT="[P] $PROMPT"
}

function disable_proxy {
    export PROMPT=$OLD_PROMPT
    unset http_proxy
    unset https_proxy
    unset all_proxy
    unset OLD_PROMPT
}

function _initJenv {
    if [ -e "$HOME/.jenv" ]; then
        export PATH="$HOME/.jenv/bin:$PATH"
        if command -v jenv 1>/dev/null 2>&1; then
            eval "$(jenv init -)"
        fi
    fi
}

function _initRBenv {
    if [ -e "$HOME/.rbenv" ]; then
        export PATH="$HOME/.rbenv/bin:$PATH"
        if command -v rbenv 1>/dev/null 2>&1; then
            eval "$(rbenv init - zsh)"
        fi
    fi
}

function _initGoenv {
    GOROOT=${GOROOT:-/usr/local/go}
    if [ -e $GOROOT ]; then
        export GOROOT=$GOROOT
        export PATH=$PATH:$GOROOT/bin
    fi
    if command -v go &>/dev/null; then
        export GOPATH=$(go env GOPATH)
        export PATH=$PATH:$GOPATH/bin
        export GO111MODULE=on
        export GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
    fi
}

function _initRustEnv {
    if command -v rustc &>/dev/null; then
        export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
        export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
    fi
    if [ -e "$HOME/.cargo" ]; then
        export PATH="$HOME/.cargo/bin":$PATH
    fi
}

function _initCuda {
    if [ -e "/usr/local/cuda" ]; then
        export PATH="/usr/local/cuda/bin$PATH"
        export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
    fi
}

function _initMacEnv {
    # homebrew
    brew_installed=(gcc) #***
    if command -v brew &>/dev/null; then
        for i in ${brew_installed[@]}; do
            INSTALLED_HOME=$(brew --prefix ${i})
            if [[ "x$?" == "x0" ]]; then
                export PATH=$INSTALLED_HOME/bin:$PATH
            fi
        done
    fi
    # macports
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    export C_INCLUDE_PATH="/opt/local/include:$C_INCLUDE_PATH"
    export LD_LIBRARY_PATH="/opt/local/lib:$LD_LIBRARY_PATH"
}

function _initHaskellEnv {
    if [ -e "$HOME/.ghcup" ]; then
        export PATH="$HOME/.ghcup/bin:$PATH"
    fi
    if [ -e "$HOME/.cabal" ]; then
        export PATH="$HOME/.cabal/bin:$PATH"
    fi
}

#+++++++++++++++++++++++++++++++++++++++
# ALIAS
#+++++++++++++++++++++++++++++++++++++++
# Git
alias ga="git add"
alias gb="git branch"
alias gba="git branch -av"
alias gd="git diff --ws-error-highlight=all"
alias gdc="git diff --cached"
alias ghf="git log --follow -p --"
alias grsh="git reset --soft HEAD^ && git reset --hard HEAD"
alias gsrh="git submodule foreach --recursive git reset --hard"
alias gsur="git submodule update --init --recursive"
alias git-quick-update="git add -u && git commit -m \"Quick update\" && git push"
alias gqu="git-quick-update"
# Use nvim as default
alias vi=nvim
alias tmux='tmux -u' #unicode-mode to fix nerdfont
# batch
alias team="pssh -i -h $HOME/.pssh_hosts"
# Proxy shortcut
alias pc="/usr/local/bin/proxychains4 -q"
# java
alias cfr="java -jar ~/bin/cfr-0.152.jar"
# Perf
alias psmem="ps -o pid,user,%mem,command ax | sort -b -k3 -r"
# StarDict console
alias sd="sdcv -0 -c"

#+++++++++++++++++++++++++++++++++++++++
# DEVTOOLS
#+++++++++++++++++++++++++++++++++++++++

_initJenv
_initRBenv
_initGoenv
_initRustEnv
_initCuda
_initHaskellEnv

#if [[ $OSTYPE == darwin*  ]]; then
#    _initMacEnv
#fi

#+++++++++++++++++++++++++++++++++++++++
# Env vars
#+++++++++++++++++++++++++++++++++++++++

export PATH=$PATH:$HOME/.local/bin
