#!/usr/bin/env bash

# don't push by default
BUILD_FLAGS=${@:-"--load"}

IMAGE_REPO=thekelvinliu/lsio-mod-plexdrive
IMAGE_VERSION=latest

docker buildx build \
  --builder bldr \
  --platform linux/arm64 \
  --tag "$IMAGE_REPO:$IMAGE_VERSION" \
  "$BUILD_FLAGS" .
