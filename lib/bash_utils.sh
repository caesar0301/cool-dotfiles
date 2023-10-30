#!/bin/bash
#----------------------------------------------
# bash_utils.sh
#
# Simple functionality wrapper to speed up daily dev.
#
# Author: xiaming.chen
#

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# colored messages
function warn {
    printf "${YELLOW}[%s] %s${NC}\n" "$(date '+%Y-%m-%dT%H:%M:%S')" "$@"
}

function info {
    printf "${GREEN}[%s] %s${NC}\n" "$(date '+%Y-%m-%dT%H:%M:%S')" "$@"
}

function error {
    printf "${RED}[%s] %s${NC}\n" "$(date '+%Y-%m-%dT%H:%M:%S')" "$@"
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
        info "has_sudo__pass_set"
    elif echo $prompt | grep -q '^sudo:'; then
        warn "has_sudo__needs_pass"
        sudo -v
    else
        error "no_sudo" && exit 1
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
