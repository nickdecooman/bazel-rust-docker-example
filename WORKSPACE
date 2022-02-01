load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Rust

http_archive(
    name = "rules_rust",
    sha256 = "1a919f80faf6a5e3ee1d0fccf84775c5f6f6ee062eb413dd9f7560b6b02008bb",
    strip_prefix = "rules_rust-1cb3c446b263c16b373e259e988f00c5f1e3f175",
    urls = [
        "https://github.com/bazelbuild/rules_rust/archive/1cb3c446b263c16b373e259e988f00c5f1e3f175.tar.gz",
    ],
)

load("@rules_rust//rust:repositories.bzl", "rust_repository_set", "rules_rust_dependencies", "rust_register_toolchains")

rules_rust_dependencies()

rust_register_toolchains(include_rustc_srcs = True)

rust_repository_set(
    name = "macos_musl_tuple",
    exec_triple = "x86_64-apple-darwin",
    extra_target_triples = ["x86_64-unknown-linux-musl"],
    version = "1.58.0",
    include_rustc_srcs = True
)

register_toolchains(
    "//build/toolchains:macos_musl_toolchain",
)

# Raze

load("//cargo:crates.bzl", "raze_fetch_remote_crates")

raze_fetch_remote_crates()

# Rust Analyzer

load("@rules_rust//tools/rust_analyzer:deps.bzl", "rust_analyzer_deps")

rust_analyzer_deps()

# Docker

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "59536e6ae64359b716ba9c46c39183403b01eabfbd57578e84398b4829ca499a",
    strip_prefix = "rules_docker-0.22.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.22.0/rules_docker-v0.22.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load(
    "@io_bazel_rules_docker//rust:image.bzl",
    _rust_image_repos = "repositories",
)

_rust_image_repos()

# Rust base image

load("@io_bazel_rules_docker//container:container.bzl", "container_pull")

container_pull(
    name = "rust_base_image",
    registry = "gcr.io",
    repository = "distroless/static-debian11",
    digest = "sha256:49f33fac9328ac595cb74bd02e6a186414191c969de0d8be34e6307c185acb8e",
)
