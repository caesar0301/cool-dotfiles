# Quick start a maven project with template
function maven-quickstart {
    mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes \
        -DarchetypeArtifactId=maven-archetype-quickstart \
        -DarchetypeVersion=1.4 $@
}

# Quick start a local http server with python
function local-http-server {
    # Check python major version
    PYV=$(python -c "import sys;t='{v[0]}'.format(v=list(sys.version_info[:1]));sys.stdout.write(t)")
    if [ "$PYV" -eq "3" ]; then
        python -m http.server 8899
    else
        python -m SimpleHTTPServer 8899
    fi
}

# Open file window
function openw {
  KNAME=$(uname -s)
  KREL=$(uname -r)
  EXE='nautilus'
  if [[ $KNAME == "Linux" ]]; then
    if [[ $KREL =~ "microsoft-standard" ]]; then
      EXE='explorer.exe'
    fi
  elif [[ $KNAME == "Darwin" ]]; then
    EXE='open'
  fi
  $EXE $@
}

# Grep and replace
function greprp {
  if [ $# -eq 2 ]; then
    spath='.'
    oldstr=$1
    newstr=$2
  elif [ $# -eq 3 ]; then
    spath=$1
    oldstr=$2
    newstr=$3
  else
    echo "Invalid param number. Usage: greprp [spath] oldstr newstr"
    exit 1
  fi
  grep -r "$oldstr" $spath | awk -F: '{print $1}' | uniq | xargs -i sed -i -E "s|$oldstr|$newstr|g" {}
}

# Reset colima env
function colima-reset-all {
  rm -rf ~/.colima ~/.lima ~/.docker
}

####################################
## Configure language environment
####################################

function _initGoenv {
    GOROOT=${GOROOT:-$HOME/.local/go}
    if [ -e $GOROOT ]; then
        export PATH=$PATH:$GOROOT/bin
    fi
    if command -v go &>/dev/null; then
        export GOROOT=$(go env GOROOT)
        export GOPATH=$(go env GOPATH)
        export GO111MODULE=on
        export GOPROXY=https://goproxy.cn,direct
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

function _initHaskellEnv {
    if [ -e "$HOME/.ghcup" ]; then
        export PATH="$HOME/.ghcup/bin:$PATH"
    fi
    if [ -e "$HOME/.cabal" ]; then
        export PATH="$HOME/.cabal/bin:$PATH"
    fi
}

# pyenv management
function _initPyenv {
    if [ -e "$HOME/.pyenv" ]; then
        export PYENV_ROOT="$HOME/.pyenv"
        [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
    fi
}

# jenv management
function _initJenv {
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
    # jenv enable-plugin export > /dev/null
}

function _initLispEnv {
  # roswell
  if [ -e "$HOME/.roswell" ]; then
    export PATH="$HOME/.roswell/bin:$PATH"
  fi
  # customize quicklisp home
  export QUICKLISP_HOME=${HOME}/quicklisp
  # allegro CL
  local ACL_HOME=${HOME}/.local/share/acl
  export PATH=${ACL_HOME}:$PATH
  # start with rlwrap
  alias sbcl="rlwrap -f $HOME/.config/rlwrap/lisp_completions --remember sbcl"
  alias alisp="rlwrap -f $HOME/.config/rlwrap/lisp_completions --remember alisp"
  alias mlisp="rlwrap -f $HOME/.config/rlwrap/lisp_completions --remember mlisp"
}

_initPyenv
_initJenv
_initGoenv
_initRustEnv
_initCuda
_initHaskellEnv
_initLispEnv
