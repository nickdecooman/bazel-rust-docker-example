# buildifier: disable=module-docstring
load("@rules_rust//rust:defs.bzl", "rust_binary")
load("@io_bazel_rules_docker//rust:image.bzl", "rust_image")
load("@io_bazel_rules_docker//container:container.bzl", "container_push")
load("//cargo:crates.bzl", "all_crate_deps")

DOCKER_REGISTRY = "xxxxx.dkr.ecr.eu-central-1.amazonaws.com"

RUSTC_FLAGS = [
  "-Copt-level=s",
  "-Clto=yes",
  "-Ccodegen-units=1",
  "-Cstrip=symbols"
]

def rust_bin(name, deps=[], **kwargs):
  rust_binary(
    name = name,
    deps = deps + all_crate_deps(),
    rustc_flags = select({
        "//:release_enabled": RUSTC_FLAGS,
        "//conditions:default": [],
    }),
    **kwargs
  )

def rust_docker_image(name, binary, **kwargs):
  rust_image(
      name = name,
      base = "@rust_base_image//image",
      binary = binary,
      **kwargs
  )

def docker_image_publish(name, image, repository, **kwargs):
  container_push(
    name = name,
    format = "Docker",
    image = image,
    registry = DOCKER_REGISTRY,
    repository = repository,
    skip_unchanged_digest = True,
    tag_file = "image.json.sha256",
    **kwargs
  )
