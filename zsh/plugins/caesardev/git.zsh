# Git aliases
alias ga="git add"
alias gb="git branch"
alias gba="git branch -av"
alias gcmm="git commit -m"
alias gd="git diff --ws-error-highlight=all"
alias gdc="git diff --cached"
alias ghf="git log --follow -p --"
alias gll="git log | less"
alias grsh="git reset --soft HEAD^ && git reset --hard HEAD"
alias gsrh="git submodule foreach --recursive git reset --hard"
alias gsur="git submodule update --init --recursive"

alias git-submodule-latest="git submodule foreach git pull origin master"

function git-reset-recurse-submodules {
    #Cleans and resets a git repo and its submodules
    #https://gist.github.com/nicktoumpelis/11214362
    git reset --hard
    git submodule sync --recursive
    git submodule update --init --force --recursive
    git clean -ffdx
    git submodule foreach --recursive git clean -ffdx
}

# Remove deleted file from git cache
function git-prune-cache {
    FILES=$(git ls-files -d)
    if [[ ! -z $FILES ]]; then
        git rm $FILES
    else
        echo "No deleted files"
    fi
}

# Remove git submodule
function git-prune-submodule {
    SUBMODULE=$1
    git submodule deinit -f -- $SUBMODULE
    rm -rf .git/modules/$SUBMODULE
    git rm -f $SUBMODULE
}

function git-quick-update {
    # Get list of both staged and unstaged modified files, removing duplicates
    modified_files=$(git diff --name-only && git diff --cached --name-only | sort -u)

    # Check if there are any modified files
    if [ -z "$modified_files" ]; then
        echo "No modified files to commit."
        return 1
    fi

    # Generate a commit message
    commit_message="Update:"
    for file in $modified_files; do
        commit_message="$commit_message \"$file\""
    done

    # Stage the modified files
    git add -u

    # Commit and push the changes
    if git commit -m "$commit_message" && git push; then
        echo "Changes committed and pushed successfully."
    else
        echo "Failed to commit and push changes."
        return 1
    fi
}
