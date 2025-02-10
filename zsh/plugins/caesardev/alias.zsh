# Editor
export EDITOR=vim
alias vi=vim
alias vim=nvim
alias em='emacs -nw'

# k8s
alias k="kubectl"

# Stat.
alias duh="du -hs .[^.]*"

# Rsync preseving symlinks, timestamps, permissions
alias rsync2="rsync -rlptgoD --progress"

# Enable search hidden files by default
alias ag='ag -u'

# Perf
alias psmem="ps -o pid,user,%mem,command ax | sort -b -k3 -r"

# StarDict console
# Install dicts into ~/.local/share/stardict/dic or /usr/share/stardict/dic
alias dict="sdcv -0 -c"

# Proxy shortcut
alias pc="proxychains4 -q"

# Ag searching
alias ag_scons='ag --ignore-dir="build" -G "(SConscript|SConstruct)"'
alias ag_cmake='ag --ignore-dir="build" -G "(ODPSBuild.txt|CMakeLists.txt|.\.cmake)"'
alias ag_bazel='ag --ignore-dir="build" -G "(BUILD|.\.bazel)"'

# java
alias java_decompile="java -jar $HOME/.local/bin/cfr-0.152.jar"

# backup file side by side
alias backup="if [ -e $1 ]; then cp $1 $1.bak.$(date +%Y%m%d%H%M%S); fi"
