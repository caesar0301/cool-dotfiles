# backup file side by side
function backup {
  if [ -e "$1" ]; then
    cp "$1" "${1}.bak.$(date +%Y%m%d%H%M%S)"
  else
    echo "$1 does not exist"
  fi
}
