#!/bin/bash
set -e

if [ -z "$SAUCE_USERNAME" ]; then
    echo "Need to set SAUCE_USERNAME"
    exit 1
fi  

if [ -z "$SAUCE_ACCESS_KEY" ]; then
    echo "Need to set SAUCE_ACCESS_KEY"
    exit 1
fi

COMMIT=`git rev-parse --short HEAD`
RUN_ID=$(cat /dev/random | LC_CTYPE=C tr -dc "[:lower:]" | head -c 8)

MERRITT_IMAGE_NAME=merritt/merritt:${COMMIT}
UI_E2E_IMAGE_NAME=merritt-ui-e2e
SAUCE_CONNECT_IMAGE_NAME=sauce-connect

MERRITT_CONTAINER_NAME=merritt-${RUN_ID}
SAUCE_CONTAINER_NAME=sauce-${RUN_ID}
TEST_CONTAINER_NAME=ui-test-${RUN_ID}
NETWORK_NAME=ui-test-${RUN_ID}

SAUCE_URL=http://${SAUCE_CONTAINER_NAME}:4445/
TEST_URL=http://${MERRITT_CONTAINER_NAME}:8080/

function url_ready {
    echo "Waiting for $1 to be ready..."

    URL_STATUS=$(
        docker run --rm -it \
            --network ${NETWORK_NAME} \
            mbentley/curl --write-out %{http_code} --silent --output /dev/null $1
    ) || true

    if [ "$URL_STATUS" -eq 200 ]
    then
        # 0 = true
        return 0 
    else
        # 1 = false
        return 1
    fi
}

# Cleanup on exit
function finish {
    echo "Cleaning up containers/networks"
    docker rm -fv ${MERRITT_CONTAINER_NAME} || true
    docker rm -fv ${SAUCE_CONTAINER_NAME} || true
    docker network rm ${NETWORK_NAME}
}
trap finish EXIT

# Create a bridge network for merrit, saucelabs connect and tests to communicate
docker network create ${NETWORK_NAME} || true

# Run the merritt backend being tested
docker run -it -d \
    --name ${MERRITT_CONTAINER_NAME} \
    --network ${NETWORK_NAME} \
    ${MERRITT_IMAGE_NAME} \
    -D run

# Wait for merritt to be ready
RETRY_TIMEOUT=24
RETRY_ATTEMPTS=0
until url_ready ${TEST_URL} || [ $RETRY_ATTEMPTS -eq $RETRY_TIMEOUT ]; do
   RETRY_ATTEMPTS=$((RETRY_ATTEMPTS++))
   sleep 5s
done

# Build a docker image with the latest suite of tests and test runner
echo "Building ${UI_E2E_IMAGE_NAME} image for ui tests"
docker build \
    -t ${UI_E2E_IMAGE_NAME} \
    -f ui/e2e/Dockerfile.e2e \
    ui/e2e

# Build a docker image containing the saucelabs proxy
echo "Building ${SAUCE_CONNECT_IMAGE_NAME} image for saucelabs connection"
docker build \
    -t ${SAUCE_CONNECT_IMAGE_NAME} \
    -f ui/e2e/Dockerfile.sauceconnect \
    ui/e2e

# Run the saucelabs proxy using provided access key and username
echo "Running ${SAUCE_CONNECT_IMAGE_NAME}"
docker run -d -it \
    --name ${SAUCE_CONTAINER_NAME} \
    --network ${NETWORK_NAME} \
	-e SAUCE_ACCESS_KEY=${SAUCE_ACCESS_KEY} \
	-e SAUCE_USERNAME=${SAUCE_USERNAME} \
	${SAUCE_CONNECT_IMAGE_NAME} -v

# Wait for sauce connect to become ready
RETRY_TIMEOUT=24
RETRY_ATTEMPTS=0
until url_ready ${SAUCE_URL} || [ $RETRY_ATTEMPTS -eq $RETRY_TIMEOUT ]; do
   RETRY_ATTEMPTS=$((RETRY_ATTEMPTS++))
   sleep 5s
done

# Run the test against saucelabs
echo "Running ${UI_E2E_IMAGE_NAME}"
docker run --rm -it \
    --name ${TEST_CONTAINER_NAME} \
    --network ${NETWORK_NAME} \
	-e SAUCE_ACCESS_KEY=${SAUCE_ACCESS_KEY} \
	-e SAUCE_USERNAME=${SAUCE_USERNAME} \
    -e TEST_URL=${TEST_URL} \
	${UI_E2E_IMAGE_NAME} $*
