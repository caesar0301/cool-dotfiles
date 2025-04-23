# Quick start a maven project with template
function maven-quickstart {
  mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4 $@
}

# Quick start a local http server with python
function local-http-server {
  # Check python major version
  PYV=$(python -c "import sys;t='{v[0]}'.format(v=list(sys.version_info[:1]));sys.stdout.write(t)")
  if [ "$PYV" -eq "3" ]; then
    python -m http.server 8899
  else
    python -m SimpleHTTPServer 8899
  fi
}

# Open file window
function openw {
  KNAME=$(uname -s)
  KREL=$(uname -r)
  EXE='nautilus'
  if [[ $KNAME == "Linux" ]]; then
    if [[ $KREL =~ "microsoft-standard" ]]; then
      EXE='explorer.exe'
    fi
  elif [[ $KNAME == "Darwin" ]]; then
    EXE='open'
  fi
  $EXE $@
}

# Grep and replace
function greprp {
  if [ $# -eq 2 ]; then
    spath='.'
    oldstr=$1
    newstr=$2
  elif [ $# -eq 3 ]; then
    spath=$1
    oldstr=$2
    newstr=$3
  else
    echo "Invalid param number. Usage: greprp [spath] oldstr newstr"
    exit 1
  fi
  grep -r "$oldstr" $spath | awk -F: '{print $1}' | uniq | xargs -i sed -i -E "s|$oldstr|$newstr|g" {}
}

# Reset colima env
function colima-reset-all {
  rm -rf ~/.colima ~/.lima ~/.docker
}
