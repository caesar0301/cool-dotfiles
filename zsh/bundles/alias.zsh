#+++++++++++++++++++++++++++++++++++++++
# Useful alias
#+++++++++++++++++++++++++++++++++++++++
# Perf
alias psmem="ps -o pid,user,%mem,command ax | sort -b -k3 -r"

# Editor
alias vi=nvim
alias em='emacs -nw'
alias diffr='diff -r'

# Stat.
alias duh="du -hs .[^.]*"

# StarDict console
# Install dicts into ~/.local/share/stardict/dic or /usr/share/stardict/dic
alias dict="sdcv -0 -c"

# Rsync preseving symlinks, timestamps, permissions
alias rsync2="rsync -rlptgoD --progress"

# Proxy shortcut
alias pc="proxychains4 -q"

# Efficicency aliases
alias cfr="java -jar ~/.local/bin/cfr-0.152.jar"
alias psmem="ps -o pid,user,%mem,command ax | sort -b -k3 -r"
alias skim="/Applications/Skim.app/Contents/MacOS/Skim"

# Git aliases
alias ga="git add"
alias gb="git branch"
alias gba="git branch -av"
alias gd="git diff --ws-error-highlight=all"
alias gdc="git diff --cached"
alias ghf="git log --follow -p --"
alias gll="git log | less"
alias grsh="git reset --soft HEAD^ && git reset --hard HEAD"
alias gsrh="git submodule foreach --recursive git reset --hard"
alias gsur="git submodule update --init --recursive"
alias git-quick-update="git add -u && git commit -m \"Quick update\" && git push"
alias git-submodule-latest="git submodule foreach git pull origin master"

# Alias from flatpak exports
function _flatpak_aliases {
    FLATPAK_HOME=/var/lib/flatpak
    FLATPAK_BIN=${FLATPAK_HOME}/exports/bin

    # shortcuts to apps installed by flatpak
    if command -v flatpak &> /dev/null; then
        export PATH=$PATH:${FLATPAK_BIN}
        if [ -e ${FLATPAK_BIN}/com.visualstudio.code ]; then
            # Specifically
            alias code="flatpak run com.visualstudio.code"
        fi
    fi

    flatpak_exports=/var/lib/flatpak/exports/bin
    if [ -e ${flatpak_exports} ]; then
        for i in `ls ${flatpak_exports}`; do
            alias run-$i="flatpak run $i"
        done
    fi
}
_flatpak_aliases

# Alias for AppImages in ~/.local/share/appimage
function _appimages_aliases {
    appimage_dir=$HOME/.local/share/appimages
    if [ -e ${appimage_dir} ]; then
        for i in `find ${appimage_dir} -name "*.AppImage"`; do
            filename=$(basename -- "$i")
            alias run-${filename%.*}="${i}"
        done
    fi
}
_appimages_aliases

