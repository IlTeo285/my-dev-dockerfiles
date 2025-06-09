# Default values
REGISTRY ?= ilteo285
IMAGE_NAME ?= debian-coding-environment
DEBIAN_VERSIONS := bullseye-slim bookworm-slim

.PHONY: all clean $(DEBIAN_VERSIONS)

all: $(DEBIAN_VERSIONS)

# Build for each Debian version
$(DEBIAN_VERSIONS):
	docker build --build-arg DEBIAN_VERSION=$@ -t $(REGISTRY)/$(IMAGE_NAME):$@ -f Dockerfile.debian-dev .
	docker build --build-arg DEBIAN_VERSION=$@ --target qt-dev   -t $(REGISTRY)/$(IMAGE_NAME):$@-qt-dev   -f Dockerfile.debian-dev .
	docker build --build-arg DEBIAN_VERSION=$@ --target base-dev -t $(REGISTRY)/$(IMAGE_NAME):$@-base-dev -f Dockerfile.debian-dev .
	if [ "$@" = "bookworm-slim" ]; then \
		docker tag $(REGISTRY)/$(IMAGE_NAME):$@ $(REGISTRY)/$(IMAGE_NAME):latest; \
	fi

# Push all images to registry
push: $(DEBIAN_VERSIONS)
	for version in $(DEBIAN_VERSIONS); do \
		docker push $(REGISTRY)/$(IMAGE_NAME):$$version; \
		docker push $(REGISTRY)/$(IMAGE_NAME):$$version-base-dev; \
		docker push $(REGISTRY)/$(IMAGE_NAME):$$version-qt-dev; \
	done
	if [ -n "$$(docker images -q $(REGISTRY)/$(IMAGE_NAME):latest)" ]; then \
		docker push $(REGISTRY)/$(IMAGE_NAME):latest; \
	fi

# Clean all built images
clean:
	for version in $(DEBIAN_VERSIONS); do \
		docker rmi -f $(REGISTRY)/$(IMAGE_NAME):$$version || true; \
		docker rmi -f $(REGISTRY)/$(IMAGE_NAME):$$version-base-dev || true; \
		docker rmi -f $(REGISTRY)/$(IMAGE_NAME):$$version-qt-dev || true; \
	done

# Build specific versions
bullseye: bullseye-slim
bookworm: bookworm-slim
trixie: trixie-slim

# Help target
help:
    @echo "Available targets:"
	@echo "  all      - Build all Debian versions (default)"
	@echo "  bullseye - Build Debian 11 (Bullseye) version"
	@echo "  bookworm - Build Debian 12 (Bookworm) version"
	@echo "  trixie   - Build Debian 13 (Trixie) version"
	@echo "  push     - Push all images to Docker registry"
	@echo "  clean    - Remove all built images"