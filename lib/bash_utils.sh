# Simple functionality wrapper to speed up daily dev.

# colored messages
function warn {
  YELLOW='\033[0;33m'
  NC='\033[0m' # No Color
  printf "${YELLOW}[%s] %s${NC}\n" "$(date '+%Y-%m-%dT%H:%M:%S')" "$@"
}

function info {
  GREEN='\033[0;32m'
  NC='\033[0m' # No Color
  printf "${GREEN}[%s] %s${NC}\n" "$(date '+%Y-%m-%dT%H:%M:%S')" "$@"
}

function error {
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  printf "${RED}[%s] %s${NC}\n" "$(date '+%Y-%m-%dT%H:%M:%S')" "$@"
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

function random_num {
  WIDTH=${0:-4}
  NUMBER=$(cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head --bytes ${WIDTH})
  if [ "$NUMBER" == "" ]; then
    NUMBER=0
  fi
  echo ${NUMBER}
}

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

function latest_release {
  local repo=$1
  local proj=$2
  link=$(curl -s https://api.github.com/repos/$repo/$proj/releases/latest | grep browser_download_url | cut -d '"' -f 4)
  echo $link
}
