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

# Pull all submodules
git-submodule-latest() {
  git submodule foreach git pull origin master
}

git-reset-recurse-submodules() {
  #Cleans and resets a git repo and its submodules
  #https://gist.github.com/nicktoumpelis/11214362
  git reset --hard
  git submodule sync --recursive
  git submodule update --init --force --recursive
  git clean -ffdx
  git submodule foreach --recursive git clean -ffdx
}

# Remove deleted file from git cache
git-prune-cache() {
  FILES=$(git ls-files -d)
  if [[ ! -z $FILES ]]; then
    git rm $FILES
  else
    echo "No deleted files"
  fi
}

# Remove git submodule
git-prune-submodule() {
  SUBMODULE=$1
  git submodule deinit -f -- $SUBMODULE
  rm -rf .git/modules/$SUBMODULE
  git rm -f $SUBMODULE
}

git-quick-update() {
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

# Prune git branch locally and remotely
git-prune-branch() {
  # Git Branch Remove (Local & Remote)
  if [ $# -eq 0 ]; then
    echo "Usage: git-prune-branch <branch_name>"
    echo "Removes specified branch locally and from origin remote"
    return 1
  fi

  local branch="$1"
  local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)

  # Safety check: prevent deletion of current branch
  if [ "$current_branch" = "$branch" ]; then
    echo -e "\033[1;31mError: Cannot delete current branch ($branch)\033[0m"
    echo "Switch to another branch first."
    return 1
  fi

  echo -e "\033[1;33mRemoving branch: $branch\033[0m"

  # Local deletion (force)
  if git branch -D "$branch" >/dev/null 2>&1; then
    echo -e "\033[1;32mLocal branch removed\033[0m"
  else
    echo -e "\033[1;31mLocal branch removal failed (maybe already gone?)\033[0m"
  fi

  # Remote deletion
  if git push origin --delete "$branch" >/dev/null 2>&1; then
    echo -e "\033[1;32mRemote branch removed from origin\033[0m"
  else
    echo -e "\033[1;31mRemote branch removal failed (maybe it didn't exist?)\033[0m"
  fi

  # Clean up tracking references
  git fetch --prune --quiet >/dev/null 2>&1
}
