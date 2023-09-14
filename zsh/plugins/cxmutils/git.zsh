#############################################################
## My custom git shortcuts
#############################################################
function git_reset_recurse_submodules {
    #Cleans and resets a git repo and its submodules
    #https://gist.github.com/nicktoumpelis/11214362
    git reset --hard
    git submodule sync --recursive
    git submodule update --init --force --recursive
    git clean -ffdx
    git submodule foreach --recursive git clean -ffdx
}

# Remove deleted file from git cache
function git_prune_cache {
    FILES=$(git ls-files -d)
    if [[ ! -z $FILES ]]; then
        git rm $FILES
    else
        echo "No deleted files"
    fi
}

# Remove git submodule
function git_prune_submodule {
    SUBMODULE=$1
    git submodule deinit -f -- $SUBMODULE
    rm -rf .git/modules/$SUBMODULE
    git rm -f $SUBMODULE
}

