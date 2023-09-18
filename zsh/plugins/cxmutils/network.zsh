#+++++++++++++++++++++++++++++++++++++++
# Proxy utilities
#
# Dependent Envs:
# PROXY_HTTP_HOST
# PROXY_HTTP_PORT
# PROXY_SOCKS_PORT
#+++++++++++++++++++++++++++++++++++++++
function proxy-on {
    if [ "x${OLD_PROMPT_PROXY}" != "x" ]; then
        echo "Proxy already ON, run proxy_off first."
        return 0
    fi
    export OLD_PROMPT_PROXY="$PROMPT"
    HHOST="${PROXY_HTTP_HOST:-127.0.0.1}"
    HPORT="${PROXY_HTTP_PORT:-7890}"
    SPORT="${PROXY_SOCKS_PORT:-7891}"
    if [[ $(uname -r) =~ "microsoft-standard" ]]; then
        PROXYH=$(/mnt/c/Windows/system32/ipconfig.exe /all |
            sed -n -E "s|.*IPv4 Address.*([0-9]{3}(\.[0-9]*){3})\(Preferred\)|\1|p" |
            grep 192.168.0 |
            tr -d '\r\n\t[:blank:]')
    fi
    export http_proxy="http://${HHOST}:${HPORT}"
    export https_proxy="http://${HHOST}:${HPORT}"
    export all_proxy="socks5://${HHOST}:${SPORT}"
    export no_proxy="127.0.0.1,localhost,*.cn"
    export PROMPT="[p]>>$PROMPT"
}

function proxy-off {
    if [ "x${OLD_PROMPT_PROXY}" != "x" ]; then
        export PROMPT=$OLD_PROMPT_PROXY
        unset OLD_PROMPT_PROXY
    fi
    if [ "x${http_proxy}" != "x" ]; then
        unset http_proxy
    fi
    if [ "x${https_proxy}" != "x" ]; then
        unset https_proxy
    fi
    if [ "${all_proxy}" != "x" ]; then
        unset all_proxy
    fi
    if [ "${no_proxy}" != "x" ]; then
        unset no_proxy
    fi
}
