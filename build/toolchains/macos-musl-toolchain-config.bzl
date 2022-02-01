# Defines the C++ settings that tell Bazel precisely how to construct C++
# commands. This is unique to C++ toolchains: other languages don't require
# anything like this.
#
# This is mostly boilerplate. It provides all the structure Bazel's C++ logic
# expects (like where to find the compiler, linker, object code copier, etc) and
# points them all to a dummy script called "dummy_compiler_linker", which is
# checked in with this example.
#
# See
# https://docs.bazel.build/versions/master/cc-toolchain-config-reference.html
# for all the gory details.

load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "action_config",
    "tool",
)
load(
    "@bazel_tools//tools/build_defs/cc:action_names.bzl",
    "CPP_LINK_EXECUTABLE_ACTION_NAME",
)

def _cc_toolchain_config_impl(ctx):
    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        toolchain_identifier = "macos-musl",
        host_system_name = "local",
        target_system_name = "linux-musl",
        target_cpu = "haswell",
        target_libc = "musl",
        compiler = "clang",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        action_configs = [
            action_config(
                action_name = CPP_LINK_EXECUTABLE_ACTION_NAME,
                enabled = True,
                tools = [tool(path = "/usr/local/bin/x86_64-linux-musl-ld")],
            ),
        ],
    )

cc_toolchain_config = rule(
    implementation = _cc_toolchain_config_impl,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)
