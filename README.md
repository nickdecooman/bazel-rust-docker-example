[![CircleCI](https://circleci.com/gh/nickdecooman/bazel-rust-docker-example/tree/main.svg?style=svg)](https://circleci.com/gh/nickdecooman/bazel-rust-docker-example/tree/main)

# bazel-rust-docker-example
This project is intended to demonstrate a Bazel setup for Rust services with Docker support. 

It has the following features:
* 🏗  [Bazel](https://bazel.build/) build system
* 🦀 Compile, test and run [Rust](https://www.rust-lang.org/) binaries, libraries and tests
* 🧰 Cargo workspace and [Cargo Raze](https://github.com/google/cargo-raze) for managing Rust dependencies
* 🧐  Support for [Rust-analyzer](https://rust-analyzer.github.io/) (and VSCode)
* ⚖️ Optimized Rust compiler flags for release targets
* 📦  Minimal Docker Rust images with [distroless/static-debian11](https://github.com/GoogleContainerTools/distroless/blob/main/base/README.md) as base image (2.36MB)
* 🚀 [CircleCI](https://circleci.com/) pipeline with Bazel [remote-cache](https://github.com/buchgr/bazel-remote) on AWS S3
* ⚙️ Support for cross-compiling Rust targets from MacOS to Linux using [Musl](https://musl.libc.org/)

## Getting Started

### Prerequisites

1. Install Rustup
2. Install Raze
