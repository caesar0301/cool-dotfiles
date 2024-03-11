# Perf
alias psmem="ps -o pid,user,%mem,command ax | sort -b -k3 -r"

# Editor
alias vi=nvim
alias em='emacs -nw'

# Stat.
alias duh="du -hs .[^.]*"

# StarDict console
# Install dicts into ~/.local/share/stardict/dic or /usr/share/stardict/dic
alias dict="sdcv -0 -c"

# Rsync preseving symlinks, timestamps, permissions
alias rsync2="rsync -rlptgoD --progress"

# Proxy shortcut
alias pc="proxychains4 -q"

# Open file window
function openw {
    KNAME=$(uname -s)
    KREL=$(uname -r)
    EXE='nautilus'
    if [[ $KNAME == "Linux" ]]; then
        if [[ $KREL =~ "microsoft-standard" ]]; then
            EXE='explorer.exe'
        fi
    elif [[ $KNAME == "Darwin"  ]]; then
        EXE='open'
    fi
    $EXE $@
}

# Greping and replace
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