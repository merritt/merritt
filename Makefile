CGO_ENABLED=0
GOOS=linux
GOARCH=amd64
COMMIT=`git rev-parse --short HEAD`
APP=merritt
REPO?=merritt/$(APP)
TAG?=latest
DEPS=$(shell go list ./... | grep -v /vendor/)

UI_BUILD_IMAGE?=merritt-ui-build:$(COMMIT)
UI_SRCS=$(shell find ui -type f \
				-not -path "ui/node_modules/*")

all: build build/ui

build:
	@go build \
		-ldflags "-w -X github.com/$(REPO)/version.GitCommit=$(COMMIT)" \
		-o build/$(APP) \
		./cmd/$(APP)

build-static:
	@go build -a \
		-tags "netgo static_build" \
		-installsuffix netgo \
		-ldflags "-w -X github.com/$(REPO)/version.GitCommit=$(COMMIT)" \
		-o build/$(APP) \
		./cmd/$(APP)

build-ui-image: $(UI_SRCS)
	@docker build \
		-t $(UI_BUILD_IMAGE) \
		-f ui/Dockerfile.ui \
		ui

build/ui: build-ui-image
	@mkdir -p build/ui && \
		docker run --rm -i $(UI_BUILD_IMAGE) | tar xvzf - -C build/ui

image: build-static build/ui
	@docker build \
		-t $(REPO):$(TAG) \
		.

release: image
	@docker push $(REPO):$(TAG)

check:
	@go vet -v $(DEPS)
	@golint $(DEPS)

test: build
	@go test -v $(shell glide novendor)

clean:
	@rm -rf build

.PHONY: all build-ui-image build-static release check test clean
