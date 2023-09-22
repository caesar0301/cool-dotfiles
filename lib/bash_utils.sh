#!/bin/bash
#----------------------------------------------
# bash_utils.sh
#
# Simple functionality wrapper to speed up daily dev.
#
# Author: xiaming.chen
#

# colored messages
function warn {
    warn_prefix="\033[33m"
    mssg_suffix="\033[00m"
    echo -e "$warn_prefix"[$(date '+%Y-%m-%dT%H:%M:%S')] "$@""$mssg_suffix"
}

function info {
    info_prefix="\033[32m"
    mssg_suffix="\033[00m"
    echo -e "$info_prefix"[$(date '+%Y-%m-%dT%H:%M:%S')] "$@""$mssg_suffix"
}

function error {
    erro_prefix="\033[31m"
    mssg_suffix="\033[00m"
    echo -e "$erro_prefix"[$(date '+%Y-%m-%dT%H:%M:%S')] "$@""$mssg_suffix"
}

# check command existence
function check_command {
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
