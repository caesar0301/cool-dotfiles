# Quick start a Maven project with template
function maven-quickstart {
  mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4 "$@"
}

# Quick start a local HTTP server with Python
function local-http-server {
  # Check Python major version
  PYV=$(python -c "import sys; print(sys.version_info[0])")
  if [ "$PYV" -eq 3 ]; then
    python -m http.server 8899
  else
    python -m SimpleHTTPServer 8899
  fi
}

# Open file window
function openw {
  local KNAME=$(uname -s)
  local KREL=$(uname -r)
  local EXE='nautilus'
  if [[ $KNAME == "Linux" ]]; then
    if [[ $KREL =~ "microsoft-standard" ]]; then
      EXE='explorer.exe'
    fi
  elif [[ $KNAME == "Darwin" ]]; then
    EXE='open'
  fi
  $EXE "$@"
}

# Grep and replace
function greprp {
  if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "Invalid parameter number. Usage: greprp [spath] oldstr newstr"
    return 1
  fi

  local spath oldstr newstr
  if [ $# -eq 2 ]; then
    spath='.'
    oldstr=$1
    newstr=$2
  elif [ $# -eq 3 ]; then
    spath=$1
    oldstr=$2
    newstr=$3
  fi

  grep -r "$oldstr" "$spath" | awk -F: '{print $1}' | uniq | xargs -I {} sed -i -E "s|$oldstr|$newstr|g" "{}"
}

# Reset Colima environment
function colima-reset-all {
  rm -rf ~/.colima ~/.lima ~/.docker
}

# Prune all docker junk data
function docker-prune-all {
  docker system prune -f
}

# Docker image tag generator
function docker-image-tag {
  TAG="${1:-notag}"
  MODE="${2:-release}"
  echo ${MODE}_$(date +"%Y%m%d%H%M%S")_${TAG}_$(git rev-parse HEAD | head -c 8)
}
