CGO_ENABLED=0
GOOS=linux
GOARCH=amd64
COMMIT=`git rev-parse --short HEAD`
APP=merritt
GIT_REPO?=merritt-project/$(APP)
DOCKER_REPO?=merritt/$(APP)
TAG?=latest
DEPS=$(shell go list ./... | grep -v /vendor/)

all: build

build:
	@go build -v -ldflags "-w -X github.com/$(REPO)/version.GitCommit=$(COMMIT)" .

build-static:
	@go build -v -a -tags "netgo static_build" -installsuffix netgo -ldflags "-w -X github.com/$(REPO)/version.GitCommit=$(COMMIT)" .

release: image
	@docker push $(REPO):$(TAG)

test: build
	@go test -v $(DEPS)

clean:
	@rm -rf $(APP)

.PHONY: build build-static release test clean