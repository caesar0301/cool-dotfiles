abspath=$(cd ${0%/*} && echo $PWD/${0##*/})
thisdir=$(dirname $abspath)
source $thisdir/commons.zsh
source $thisdir/dev-tools.zsh
source $thisdir/docker.zsh
source $thisdir/git.zsh
source $thisdir/proxy.zsh