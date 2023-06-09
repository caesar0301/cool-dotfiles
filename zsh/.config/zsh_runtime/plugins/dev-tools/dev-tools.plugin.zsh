#+++++++++++++++++++++++++++++++++++++++
# DEVTOOLS
#+++++++++++++++++++++++++++++++++++++++
alias cfr="java -jar ~/bin/cfr-0.152.jar"
alias psmem="ps -o pid,user,%mem,command ax | sort -b -k3 -r"
alias skim="/Applications/Skim.app/Contents/MacOS/Skim"

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

_initJenv
_initRBenv
_initGoenv
_initRustEnv
_initCuda
_initHaskellEnv

#if [[ $OSTYPE == darwin*  ]]; then
#    _initMacEnv
#fi
