CGO_ENABLED=0
GOOS=linux
GOARCH=amd64
COMMIT=`git rev-parse --short HEAD`
APP=merritt
REPO?=merritt/$(APP)
TAG?=latest
DEPS=$(shell go list ./... | grep -v /vendor/)

BUILD_OUTPUT_DIR?=build

UI_BUILD_IMAGE?=merritt-ui-build:$(COMMIT)
UI_BUILD_SRCS=$(shell find ui -type f \
				-not -path "ui/e2e/*" \
				-not -path "ui/node_modules/*")
UI_BUILD_OUTPUT_DIR?=$(BUILD_OUTPUT_DIR)/ui

all: build build/ui

build:
	@echo "Building binary: $(BUILD_OUTPUT_DIR)/$(APP)"
	@go build \
		-ldflags "-w -X github.com/$(REPO)/version.GitCommit=$(COMMIT)" \
		-o $(BUILD_OUTPUT_DIR)/$(APP) \
		./cmd/$(APP)

build-static:
	@echo "Building static binary: $(BUILD_OUTPUT_DIR)/$(APP)"
	@go build -a \
		-tags "netgo static_build" \
		-installsuffix netgo \
		-ldflags "-w -X github.com/$(REPO)/version.GitCommit=$(COMMIT)" \
		-o $(BUILD_OUTPUT_DIR)/$(APP) \
		./cmd/$(APP)

build-ui-image: $(UI_BUILD_SRCS)
	@echo "Building UI build image: $(UI_BUILD_IMAGE)"
	@docker build \
		-t $(UI_BUILD_IMAGE) \
		-f ui/Dockerfile.ui \
		ui

build/ui: build-ui-image
	@echo "Extracting UI build image to $(UI_BUILD_OUTPUT_DIR): $(UI_BUILD_IMAGE)"
	@mkdir -p build/ui && \
		docker run --rm -i $(UI_BUILD_IMAGE) | tar xvzf - -C $(UI_BUILD_OUTPUT_DIR)

image: build-static build/ui
	@echo "Building $(REPO):$(TAG) image"
	@docker build \
		-t $(REPO):$(TAG) \
		. && \
		docker tag $(REPO):$(TAG) $(REPO):$(COMMIT)

release: image
	@echo "Releasing $(REPO):$(TAG)"
	@docker push $(REPO):$(TAG)

check:
	@go vet -v $(DEPS)
	@golint $(DEPS)

test: build
	@go test -v $(DEPS)

test-ui: build-ui-image
	@echo Running UI jest suite: $(UI_BUILD_IMAGE)
	@docker run --rm -i \
		-e CI=true\
		$(UI_BUILD_IMAGE) \
		yarn test

clean:
	@rm -rf build

.PHONY: all build build-static build-ui-image image release check test clean
