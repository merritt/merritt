#!/bin/bash
set -e

BUILD_IMAGE_NAME=merritt-build

docker build -t ${BUILD_IMAGE_NAME} -f Dockerfile.build .

docker run --rm -it \
    -v $(pwd):/go/src/github.com/merritt/merritt \
    -v /var/run/docker.sock:/var/run/docker.sock \
	${BUILD_IMAGE_NAME} $*
