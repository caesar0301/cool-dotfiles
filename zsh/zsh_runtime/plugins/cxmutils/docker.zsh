#+++++++++++++++++++++++++++++++++++++++
# Docker utiles
#+++++++++++++++++++++++++++++++++++++++

# Prune all docker junk data
function docker_prune_all {
    yes y | docker container prune
    yes y | docker image prune
    yes y | docker volume prune
}

# Docker image tag generator
function docker_gen_image_version {
    TAG="${1:-notag}"
    MODE="${2:-release}"
    echo ${MODE}_$(date +"%Y%m%d%H%M%S")_${TAG}_$(git rev-parse HEAD | head -c 8)
}
