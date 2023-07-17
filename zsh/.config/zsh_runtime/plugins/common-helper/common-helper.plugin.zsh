export PATH=$PATH:$HOME/.local/bin

# Use nvim as default
alias vi=nvim

# StarDict console
alias sd="sdcv -0 -c"

# Rsync preseving symlinks, timestamps, permissions
alias rsync2="rsync -rlptgoD --progress"

function replace {
    sourcestr="$1"
    targetstr="$2"
    pathstr="$3"
    grep -r $sourcestr $pathstr | awk -F: '{print $1}' | uniq | xargs -i sed -i -E "s|$sourcestr|$targetstr|g" {}
}