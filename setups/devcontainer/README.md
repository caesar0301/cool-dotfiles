# DevContainerImage

## How to build

```bash
docker buildx build \
    --progress=plain \
    --build-arg http_proxy=http://host.docker.internal:7890 \
    --build-arg https_proxy=http://host.docker.internal:7890 \
    --build-arg no_proxy=localhost,host.docker.internal \
    -t registry.cn-hangzhou.aliyuncs.com/lacogito/devcontainer:ubuntu2404-v250416 .
```
