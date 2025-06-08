# Development Containers for C++/Rust

This repository contains Docker configurations for setting up consistent development environments for C++ and Rust projects.

## Features

- Debian-based development environment
- Latest LLVM/Clang toolchain
- CMake 3.31.7 built from source
- Ninja build system
- vcpkg package manager
- Development tools:
  - GDB debugger
  - Valgrind memory checker
  - ccache compiler cache
  - clang-format code formatter
  - clang-tidy static analyzer
- Documentation tools:
  - Doxygen with modern HTML output
  - Moxygen for Markdown generation
- ZSH shell with modern setup
- Non-root user setup with sudo access
- UTF-8 locale configuration

## Usage

### Basic Build

```bash
docker build -t dev-container -f Dockerfile.debian-dev .
```

### Customizing Debian Version

You can specify a different Debian version during build:

```bash
docker build --build-arg DEBIAN_VERSION=bookworm-slim -t dev-container -f Dockerfile.debian-dev .
```

Available versions:
- `bullseye-slim` (Debian 11)
- `bookworm-slim` (Debian 12)
- `trixie-slim` (Debian 13/testing)

### Building Base Development Environment

If you only want the base development environment without additional configuration:

```bash
docker build --target base-dev -t dev-base -f Dockerfile.debian-dev .
```

This will build only the `base-dev` target, which includes all development tools but skips the Ansible configuration step.

### Using Pre-built Image

A pre-built version of this environment is available on Docker Hub:

```bash
docker pull ilteo285/debian-coding-environment
```

You can also directly reference this image in your Docker configurations:

```dockerfile
FROM ilteo285/debian-coding-environment:latest
```

Available tags:
- `latest`: Most recent stable build
- `base-dev`: Base development environment only
