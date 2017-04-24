#!/bin/bash
set -e

BUILD_IMAGE_NAME=merritt-build

echo "Building ${BUILD_IMAGE_NAME} image for dev tooling"
docker build -t ${BUILD_IMAGE_NAME} -f Dockerfile.build .

echo "Running ${BUILD_IMAGE_NAME}"
docker run --rm -it \
    -v $(pwd):/go/src/github.com/merritt/merritt \
    -v /var/run/docker.sock:/var/run/docker.sock \
	${BUILD_IMAGE_NAME} make $*