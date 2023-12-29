# update dotfiles
function dotup {
    DOTHOME=${DOTHOME:-$HOME/.dotfiles}
    CURDIR=$(pwd)
    cd $DOTHOME && git pull && $DOTHOME/install_all.sh
    cd $CURDIR
    zshup
    nvimup
    echo "$HOME/.dotfiles updated"
}

# Update zinit and plugins
function zshup {
    # self update
    zinit self-update
    # plugin update
    zinit update --parallel
    # update user plugins
    old_path=$(pwd)
    if [ -e ${ZSH_PLUGIN_DIR} ]; then
        for plugin in $(ls -d $ZSH_PLUGIN_DIR/*); do
            if [ -e ${plugin}/.git ]; then
                echo -n "Updating plugin ${plugin}..."
                cd $plugin && git pull -q && echo "done" && cd ${old_path}
            fi
        done
    fi
}

# update nvim plugins
function nvimup {
    nvim -c "PackerInstall" -c "PackerSync" \
        -c "TSInstall lua python java go scala"
}