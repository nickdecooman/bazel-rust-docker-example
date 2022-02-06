[![CircleCI](https://circleci.com/gh/nickdecooman/bazel-rust-docker-example/tree/main.svg?style=svg)](https://circleci.com/gh/nickdecooman/bazel-rust-docker-example/tree/main)

# bazel-rust-docker-example
This project is intended to demonstrate a Bazel setup for Rust services with Docker support. 

It has the following features:
* 🏗  [Bazel](https://bazel.build/) build system
* 🦀 Compile, test and run [Rust](https://www.rust-lang.org/) binaries, libraries and tests
* 🧰 Cargo workspace and [Cargo Raze](https://github.com/google/cargo-raze) for managing Rust dependencies
* 🧐  Support for [Rust-analyzer](https://rust-analyzer.github.io/) (and VS Code)
* ⚖️ Optimized Rust compiler flags for release targets
* 📦  Minimal Docker Rust images with [distroless/static-debian11](https://github.com/GoogleContainerTools/distroless/blob/main/base/README.md) as base image (2.36MB)
* 🚀 [CircleCI](https://circleci.com/) pipeline with Bazel [remote-cache](https://github.com/buchgr/bazel-remote) on AWS S3
* ⚙️ Support for cross-compiling Rust targets from MacOS to Linux using [Musl](https://musl.libc.org/)

## Prerequisites

* Install [Bazelisk](https://github.com/bazelbuild/bazelisk)

* Install [Rustup](https://rustup.rs/)

* Install [Cargo Raze](https://github.com/google/cargo-raze)
```bash
$ cargo install cargo-raze
```

* For cross-compilation from MacOS to Linux musl targets, install [musl-cross](https://github.com/FiloSottile/homebrew-musl-cross)
```bash
$ brew install filosottile/musl-cross/musl-cross
```

* For Bazel remote cache, install [https://github.com/buchgr/bazel-remote](https://github.com/buchgr/bazel-remote)

## Bazel Commands

### Build the entire project:

```bash
$ bazel build //...
```

### Run all tests:

```bash
$ bazel test //...
```

### Run service1 natively:

```bash
$ bazel run //service1:app
```

### Run service1 within a Docker container:

```bash
$ bazel run //service1:image
```
⚠️ This only works when your host machine is Linux. Look for cross-compiling below when building on MacOS.

### Run service1 within an optimzed release Docker container:

```bash
$ bazel run //service1:image --//:release
```

⚠️ This only works when your host machine is Linux. Look for cross-compiling below when building on MacOS.

### Cross-compile service1 from MacOS to Linux and run within a Docker container:

```bash
$ bazel run //service1:image --platforms //build/platform:musl
```

Can also be combined with ` --//:release`.

## Rust-Analyzer

In order for Rust-Analyzer to work, it is necessary to generate a `rust-project.json` file. To do so, run

```bash
$ bazel run @rules_rust//tools/rust_analyzer:gen_rust_project
```

## VS Code

When using VS Code as IDE, install the following extension for Rust-Analyzer: https://marketplace.visualstudio.com/items?itemName=matklad.rust-analyzer

In your VS Code `settings.json`, make sure to have the following configuration:

```json
{ 
  "rust-analyzer.checkOnSave.overrideCommand": ["cargo", "check" "--message-format=json"]
}
```

The Rust-Analyzer extension will pick up the `rust-project.json` file which was generated earlier.

⚠️ Make sure to generate an updated `rust-project.json` file whenever a new folder or dependency is added. It may also be needed to reload the workspace when the updated structure is not immediately recognized by Rust-Analyzer.

## Cargo Dependencies

For each of the dependencies listed in any of the `Cargo.toml` files, a Bazel build should be generated. This is done automatically by running

```bash
$ cargo raze
```

If not already the case, this will add a `cargo` folder in the root of the project. Crates can now be referenced fron within Bazel through `//cargo/*NAME*` (eg. `//cargo/ferris_says`).

### Adding a new dependency

After adding a new external dependency in any of the `Cargo.toml` files, run the following steps:

1. Run `cargo raze --generate-lockfile`
2. Run `bazel build //...`
3. Update `rust-project.json` by running `bazel run @rules_rust//tools/rust_analyzer:gen_rust_project`
4. Reload Rust Workspace in VS Code
5. Start using crate in your Rust library or binary

## Cross-compiling

This project provides a basic setup for cross-compiling from MacOS to Linux. The setup is inspired by [rust-bazel-cross](https://github.com/duarten/rust-bazel-cross).

⚠️ A known limitation is that dependencies relying on macros fail to compile. More info [here](https://github.com/duarten/rust-bazel-cross/issues/2).

## Bazel remote-cache

When applying the Bazel config flag `--config=remote_cache`, Bazel will connect to a remote cache running at `localhost:9090`. This server will sync files between a local cache and an AWS S3 bucket.

To start the bazel-remote server, run the script `./scripts/start_bazel_remote.sh`. Provide the following environment variables:
* *AWS_REGION*
* *AWS_ACCESS_KEY_ID*
* *AWS_SECRET_ACCESS_KEY*
* *AWS_S3_BUCKET_BAZEL_CACHE*

## Did this help you?

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/N4N5ADJPF)
