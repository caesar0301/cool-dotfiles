# Alias from flatpak exports
function _flatpak_aliases {
    FLATPAK_HOME=/var/lib/flatpak
    FLATPAK_BIN=${FLATPAK_HOME}/exports/bin

    # shortcuts to apps installed by flatpak
    if command -v flatpak &>/dev/null; then
        export PATH=$PATH:${FLATPAK_BIN}
        if [ -e ${FLATPAK_BIN}/com.visualstudio.code ]; then
            # Specifically
            alias code="flatpak run com.visualstudio.code"
        fi
    fi

    flatpak_exports=/var/lib/flatpak/exports/bin
    if [ -e ${flatpak_exports} ]; then
        for i in $(ls ${flatpak_exports}); do
            alias run-$i="flatpak run $i"
        done
    fi
}
_flatpak_aliases

# Alias for AppImages in ~/.local/share/appimage
function _appimages_aliases {
    appimage_dir=$HOME/.local/share/appimages
    if [ -e ${appimage_dir} ]; then
        for i in $(find ${appimage_dir} -name "*.AppImage"); do
            filename=$(basename -- "$i")
            alias run-${filename%.*}="${i}"
        done
    fi
}
_appimages_aliases
