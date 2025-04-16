#!/bin/bash

# -------------------------------
# Configuration
IMAGE_NAME="registry.cn-hangzhou.aliyuncs.com/lacogito/devcontainer:ubuntu2404-v250416"
CONTAINER_NAME="mydevc"
PROXY_HOST="host.docker.internal"
PROXY_PORT="7890"
# -------------------------------

# Full proxy URL
PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"

echo "👉 Checking if container '$CONTAINER_NAME' exists..."

# Check if container exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "🛑 Container '$CONTAINER_NAME' exists. Stopping and removing it..."
  docker stop "$CONTAINER_NAME" >/dev/null
  docker rm "$CONTAINER_NAME" >/dev/null
else
  echo "✅ No existing container named '$CONTAINER_NAME'."
fi

echo "🚀 Starting new container '$CONTAINER_NAME' in daemon mode..."

# Run the container in daemon mode with proxy and keep it alive
docker run -d \
  --name "$CONTAINER_NAME" \
  -e http_proxy="$PROXY_URL" \
  -e https_proxy="$PROXY_URL" \
  -e no_proxy="localhost,127.0.0.1,$PROXY_HOST" \
  -v $(pwd)/devc_workdata:/home/admin/workspace/ \
  "$IMAGE_NAME" \
  tail -f /dev/null

echo "✅ Container '$CONTAINER_NAME' is running."

# Optional: install zsh if not in the base image
# echo "📦 Installing zsh inside the container..."
# docker exec -it "$CONTAINER_NAME" bash -c "apt update && apt install -y zsh"

echo "💻 Executing zsh inside the container..."
docker exec -it "$CONTAINER_NAME" zsh

