"""
@generated
cargo-raze generated Bazel file.

DO NOT EDIT! Replaced on runs of cargo-raze
"""

load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")  # buildifier: disable=load
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")  # buildifier: disable=load
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")  # buildifier: disable=load

# EXPERIMENTAL -- MAY CHANGE AT ANY TIME: A mapping of package names to a set of normal dependencies for the Rust targets of that package.
_DEPENDENCIES = {
    "service1": {
        "ferris-says": "@raze__ferris_says__0_2_1//:ferris_says",
        "postgres": "@raze__postgres__0_19_2//:postgres",
    },
    "helper1": {
    },
}

# EXPERIMENTAL -- MAY CHANGE AT ANY TIME: A mapping of package names to a set of proc_macro dependencies for the Rust targets of that package.
_PROC_MACRO_DEPENDENCIES = {
    "service1": {
    },
    "helper1": {
    },
}

# EXPERIMENTAL -- MAY CHANGE AT ANY TIME: A mapping of package names to a set of normal dev dependencies for the Rust targets of that package.
_DEV_DEPENDENCIES = {
    "service1": {
    },
    "helper1": {
    },
}

# EXPERIMENTAL -- MAY CHANGE AT ANY TIME: A mapping of package names to a set of proc_macro dev dependencies for the Rust targets of that package.
_DEV_PROC_MACRO_DEPENDENCIES = {
    "service1": {
    },
    "helper1": {
    },
}

def crate_deps(deps, package_name = None):
    """EXPERIMENTAL -- MAY CHANGE AT ANY TIME: Finds the fully qualified label of the requested crates for the package where this macro is called.

    WARNING: This macro is part of an expeirmental API and is subject to change.

    Args:
        deps (list): The desired list of crate targets.
        package_name (str, optional): The package name of the set of dependencies to look up.
            Defaults to `native.package_name()`.
    Returns:
        list: A list of labels to cargo-raze generated targets (str)
    """

    if not package_name:
        package_name = native.package_name()

    # Join both sets of dependencies
    dependencies = _flatten_dependency_maps([
        _DEPENDENCIES,
        _PROC_MACRO_DEPENDENCIES,
        _DEV_DEPENDENCIES,
        _DEV_PROC_MACRO_DEPENDENCIES,
    ])

    if not deps:
        return []

    missing_crates = []
    crate_targets = []
    for crate_target in deps:
        if crate_target not in dependencies[package_name]:
            missing_crates.append(crate_target)
        else:
            crate_targets.append(dependencies[package_name][crate_target])

    if missing_crates:
        fail("Could not find crates `{}` among dependencies of `{}`. Available dependencies were `{}`".format(
            missing_crates,
            package_name,
            dependencies[package_name],
        ))

    return crate_targets

def all_crate_deps(normal = False, normal_dev = False, proc_macro = False, proc_macro_dev = False, package_name = None):
    """EXPERIMENTAL -- MAY CHANGE AT ANY TIME: Finds the fully qualified label of all requested direct crate dependencies \
    for the package where this macro is called.

    If no parameters are set, all normal dependencies are returned. Setting any one flag will
    otherwise impact the contents of the returned list.

    Args:
        normal (bool, optional): If True, normal dependencies are included in the
            output list. Defaults to False.
        normal_dev (bool, optional): If True, normla dev dependencies will be
            included in the output list. Defaults to False.
        proc_macro (bool, optional): If True, proc_macro dependencies are included
            in the output list. Defaults to False.
        proc_macro_dev (bool, optional): If True, dev proc_macro dependencies are
            included in the output list. Defaults to False.
        package_name (str, optional): The package name of the set of dependencies to look up.
            Defaults to `native.package_name()`.

    Returns:
        list: A list of labels to cargo-raze generated targets (str)
    """

    if not package_name:
        package_name = native.package_name()

    # Determine the relevant maps to use
    all_dependency_maps = []
    if normal:
        all_dependency_maps.append(_DEPENDENCIES)
    if normal_dev:
        all_dependency_maps.append(_DEV_DEPENDENCIES)
    if proc_macro:
        all_dependency_maps.append(_PROC_MACRO_DEPENDENCIES)
    if proc_macro_dev:
        all_dependency_maps.append(_DEV_PROC_MACRO_DEPENDENCIES)

    # Default to always using normal dependencies
    if not all_dependency_maps:
        all_dependency_maps.append(_DEPENDENCIES)

    dependencies = _flatten_dependency_maps(all_dependency_maps)

    if not dependencies:
        return []

    return dependencies[package_name].values()

def _flatten_dependency_maps(all_dependency_maps):
    """Flatten a list of dependency maps into one dictionary.

    Dependency maps have the following structure:

    ```python
    DEPENDENCIES_MAP = {
        # The first key in the map is a Bazel package
        # name of the workspace this file is defined in.
        "package_name": {

            # An alias to a crate target.     # The label of the crate target the
            # Aliases are only crate names.   # alias refers to.
            "alias":                          "@full//:label",
        }
    }
    ```

    Args:
        all_dependency_maps (list): A list of dicts as described above

    Returns:
        dict: A dictionary as described above
    """
    dependencies = {}

    for dep_map in all_dependency_maps:
        for pkg_name in dep_map:
            if pkg_name not in dependencies:
                # Add a non-frozen dict to the collection of dependencies
                dependencies.setdefault(pkg_name, dict(dep_map[pkg_name].items()))
                continue

            duplicate_crate_aliases = [key for key in dependencies[pkg_name] if key in dep_map[pkg_name]]
            if duplicate_crate_aliases:
                fail("There should be no duplicate crate aliases: {}".format(duplicate_crate_aliases))

            dependencies[pkg_name].update(dep_map[pkg_name])

    return dependencies

def raze_fetch_remote_crates():
    """This function defines a collection of repos and should be called in a WORKSPACE file"""
    maybe(
        http_archive,
        name = "raze__async_trait__0_1_52",
        url = "https://crates.io/api/v1/crates/async-trait/0.1.52/download",
        type = "tar.gz",
        sha256 = "061a7acccaa286c011ddc30970520b98fa40e00c9d644633fb26b5fc63a265e3",
        strip_prefix = "async-trait-0.1.52",
        build_file = Label("//cargo/remote:BUILD.async-trait-0.1.52.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__base64__0_13_0",
        url = "https://crates.io/api/v1/crates/base64/0.13.0/download",
        type = "tar.gz",
        sha256 = "904dfeac50f3cdaba28fc6f57fdcddb75f49ed61346676a78c4ffe55877802fd",
        strip_prefix = "base64-0.13.0",
        build_file = Label("//cargo/remote:BUILD.base64-0.13.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__bitflags__1_3_2",
        url = "https://crates.io/api/v1/crates/bitflags/1.3.2/download",
        type = "tar.gz",
        sha256 = "bef38d45163c2f1dde094a7dfd33ccf595c92905c8f8f4fdc18d06fb1037718a",
        strip_prefix = "bitflags-1.3.2",
        build_file = Label("//cargo/remote:BUILD.bitflags-1.3.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__block_buffer__0_10_2",
        url = "https://crates.io/api/v1/crates/block-buffer/0.10.2/download",
        type = "tar.gz",
        sha256 = "0bf7fe51849ea569fd452f37822f606a5cabb684dc918707a0193fd4664ff324",
        strip_prefix = "block-buffer-0.10.2",
        build_file = Label("//cargo/remote:BUILD.block-buffer-0.10.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__byteorder__1_4_3",
        url = "https://crates.io/api/v1/crates/byteorder/1.4.3/download",
        type = "tar.gz",
        sha256 = "14c189c53d098945499cdfa7ecc63567cf3886b3332b312a5b4585d8d3a6a610",
        strip_prefix = "byteorder-1.4.3",
        build_file = Label("//cargo/remote:BUILD.byteorder-1.4.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__bytes__1_1_0",
        url = "https://crates.io/api/v1/crates/bytes/1.1.0/download",
        type = "tar.gz",
        sha256 = "c4872d67bab6358e59559027aa3b9157c53d9358c51423c17554809a8858e0f8",
        strip_prefix = "bytes-1.1.0",
        build_file = Label("//cargo/remote:BUILD.bytes-1.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cfg_if__1_0_0",
        url = "https://crates.io/api/v1/crates/cfg-if/1.0.0/download",
        type = "tar.gz",
        sha256 = "baf1de4339761588bc0619e3cbc0120ee582ebb74b53b4efbf79117bd2da40fd",
        strip_prefix = "cfg-if-1.0.0",
        build_file = Label("//cargo/remote:BUILD.cfg-if-1.0.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cpufeatures__0_2_1",
        url = "https://crates.io/api/v1/crates/cpufeatures/0.2.1/download",
        type = "tar.gz",
        sha256 = "95059428f66df56b63431fdb4e1947ed2190586af5c5a8a8b71122bdf5a7f469",
        strip_prefix = "cpufeatures-0.2.1",
        build_file = Label("//cargo/remote:BUILD.cpufeatures-0.2.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crypto_common__0_1_2",
        url = "https://crates.io/api/v1/crates/crypto-common/0.1.2/download",
        type = "tar.gz",
        sha256 = "a4600d695eb3f6ce1cd44e6e291adceb2cc3ab12f20a33777ecd0bf6eba34e06",
        strip_prefix = "crypto-common-0.1.2",
        build_file = Label("//cargo/remote:BUILD.crypto-common-0.1.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__digest__0_10_2",
        url = "https://crates.io/api/v1/crates/digest/0.10.2/download",
        type = "tar.gz",
        sha256 = "8cb780dce4f9a8f5c087362b3a4595936b2019e7c8b30f2c3e9a7e94e6ae9837",
        strip_prefix = "digest-0.10.2",
        build_file = Label("//cargo/remote:BUILD.digest-0.10.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__fallible_iterator__0_2_0",
        url = "https://crates.io/api/v1/crates/fallible-iterator/0.2.0/download",
        type = "tar.gz",
        sha256 = "4443176a9f2c162692bd3d352d745ef9413eec5782a80d8fd6f8a1ac692a07f7",
        strip_prefix = "fallible-iterator-0.2.0",
        build_file = Label("//cargo/remote:BUILD.fallible-iterator-0.2.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__ferris_says__0_2_1",
        url = "https://crates.io/api/v1/crates/ferris-says/0.2.1/download",
        type = "tar.gz",
        sha256 = "9515ec2dd9606ec230f6b2d1f25fd9e808a2f2af600143f7efe7e5865505b7aa",
        strip_prefix = "ferris-says-0.2.1",
        build_file = Label("//cargo/remote:BUILD.ferris-says-0.2.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures__0_3_21",
        url = "https://crates.io/api/v1/crates/futures/0.3.21/download",
        type = "tar.gz",
        sha256 = "f73fe65f54d1e12b726f517d3e2135ca3125a437b6d998caf1962961f7172d9e",
        strip_prefix = "futures-0.3.21",
        build_file = Label("//cargo/remote:BUILD.futures-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_channel__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-channel/0.3.21/download",
        type = "tar.gz",
        sha256 = "c3083ce4b914124575708913bca19bfe887522d6e2e6d0952943f5eac4a74010",
        strip_prefix = "futures-channel-0.3.21",
        build_file = Label("//cargo/remote:BUILD.futures-channel-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_core__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-core/0.3.21/download",
        type = "tar.gz",
        sha256 = "0c09fd04b7e4073ac7156a9539b57a484a8ea920f79c7c675d05d289ab6110d3",
        strip_prefix = "futures-core-0.3.21",
        build_file = Label("//cargo/remote:BUILD.futures-core-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_executor__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-executor/0.3.21/download",
        type = "tar.gz",
        sha256 = "9420b90cfa29e327d0429f19be13e7ddb68fa1cccb09d65e5706b8c7a749b8a6",
        strip_prefix = "futures-executor-0.3.21",
        build_file = Label("//cargo/remote:BUILD.futures-executor-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_io__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-io/0.3.21/download",
        type = "tar.gz",
        sha256 = "fc4045962a5a5e935ee2fdedaa4e08284547402885ab326734432bed5d12966b",
        strip_prefix = "futures-io-0.3.21",
        build_file = Label("//cargo/remote:BUILD.futures-io-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_macro__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-macro/0.3.21/download",
        type = "tar.gz",
        sha256 = "33c1e13800337f4d4d7a316bf45a567dbcb6ffe087f16424852d97e97a91f512",
        strip_prefix = "futures-macro-0.3.21",
        build_file = Label("//cargo/remote:BUILD.futures-macro-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_sink__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-sink/0.3.21/download",
        type = "tar.gz",
        sha256 = "21163e139fa306126e6eedaf49ecdb4588f939600f0b1e770f4205ee4b7fa868",
        strip_prefix = "futures-sink-0.3.21",
        build_file = Label("//cargo/remote:BUILD.futures-sink-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_task__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-task/0.3.21/download",
        type = "tar.gz",
        sha256 = "57c66a976bf5909d801bbef33416c41372779507e7a6b3a5e25e4749c58f776a",
        strip_prefix = "futures-task-0.3.21",
        build_file = Label("//cargo/remote:BUILD.futures-task-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_util__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-util/0.3.21/download",
        type = "tar.gz",
        sha256 = "d8b7abd5d659d9b90c8cba917f6ec750a74e2dc23902ef9cd4cc8c8b22e6036a",
        strip_prefix = "futures-util-0.3.21",
        build_file = Label("//cargo/remote:BUILD.futures-util-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__generic_array__0_14_5",
        url = "https://crates.io/api/v1/crates/generic-array/0.14.5/download",
        type = "tar.gz",
        sha256 = "fd48d33ec7f05fbfa152300fdad764757cbded343c1aa1cff2fbaf4134851803",
        strip_prefix = "generic-array-0.14.5",
        build_file = Label("//cargo/remote:BUILD.generic-array-0.14.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__getrandom__0_2_4",
        url = "https://crates.io/api/v1/crates/getrandom/0.2.4/download",
        type = "tar.gz",
        sha256 = "418d37c8b1d42553c93648be529cb70f920d3baf8ef469b74b9638df426e0b4c",
        strip_prefix = "getrandom-0.2.4",
        build_file = Label("//cargo/remote:BUILD.getrandom-0.2.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__hmac__0_12_0",
        url = "https://crates.io/api/v1/crates/hmac/0.12.0/download",
        type = "tar.gz",
        sha256 = "ddca131f3e7f2ce2df364b57949a9d47915cfbd35e46cfee355ccebbf794d6a2",
        strip_prefix = "hmac-0.12.0",
        build_file = Label("//cargo/remote:BUILD.hmac-0.12.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__instant__0_1_12",
        url = "https://crates.io/api/v1/crates/instant/0.1.12/download",
        type = "tar.gz",
        sha256 = "7a5bbe824c507c5da5956355e86a746d82e0e1464f65d862cc5e71da70e94b2c",
        strip_prefix = "instant-0.1.12",
        build_file = Label("//cargo/remote:BUILD.instant-0.1.12.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__libc__0_2_117",
        url = "https://crates.io/api/v1/crates/libc/0.2.117/download",
        type = "tar.gz",
        sha256 = "e74d72e0f9b65b5b4ca49a346af3976df0f9c61d550727f349ecd559f251a26c",
        strip_prefix = "libc-0.2.117",
        build_file = Label("//cargo/remote:BUILD.libc-0.2.117.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__lock_api__0_4_6",
        url = "https://crates.io/api/v1/crates/lock_api/0.4.6/download",
        type = "tar.gz",
        sha256 = "88943dd7ef4a2e5a4bfa2753aaab3013e34ce2533d1996fb18ef591e315e2b3b",
        strip_prefix = "lock_api-0.4.6",
        build_file = Label("//cargo/remote:BUILD.lock_api-0.4.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__log__0_4_14",
        url = "https://crates.io/api/v1/crates/log/0.4.14/download",
        type = "tar.gz",
        sha256 = "51b9bbe6c47d51fc3e1a9b945965946b4c44142ab8792c50835a980d362c2710",
        strip_prefix = "log-0.4.14",
        build_file = Label("//cargo/remote:BUILD.log-0.4.14.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__md_5__0_10_0",
        url = "https://crates.io/api/v1/crates/md-5/0.10.0/download",
        type = "tar.gz",
        sha256 = "e6a38fc55c8bbc10058782919516f88826e70320db6d206aebc49611d24216ae",
        strip_prefix = "md-5-0.10.0",
        build_file = Label("//cargo/remote:BUILD.md-5-0.10.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__memchr__2_4_1",
        url = "https://crates.io/api/v1/crates/memchr/2.4.1/download",
        type = "tar.gz",
        sha256 = "308cc39be01b73d0d18f82a0e7b2a3df85245f84af96fdddc5d202d27e47b86a",
        strip_prefix = "memchr-2.4.1",
        build_file = Label("//cargo/remote:BUILD.memchr-2.4.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__mio__0_7_14",
        url = "https://crates.io/api/v1/crates/mio/0.7.14/download",
        type = "tar.gz",
        sha256 = "8067b404fe97c70829f082dec8bcf4f71225d7eaea1d8645349cb76fa06205cc",
        strip_prefix = "mio-0.7.14",
        build_file = Label("//cargo/remote:BUILD.mio-0.7.14.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__miow__0_3_7",
        url = "https://crates.io/api/v1/crates/miow/0.3.7/download",
        type = "tar.gz",
        sha256 = "b9f1c5b025cda876f66ef43a113f91ebc9f4ccef34843000e0adf6ebbab84e21",
        strip_prefix = "miow-0.3.7",
        build_file = Label("//cargo/remote:BUILD.miow-0.3.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__ntapi__0_3_6",
        url = "https://crates.io/api/v1/crates/ntapi/0.3.6/download",
        type = "tar.gz",
        sha256 = "3f6bb902e437b6d86e03cce10a7e2af662292c5dfef23b65899ea3ac9354ad44",
        strip_prefix = "ntapi-0.3.6",
        build_file = Label("//cargo/remote:BUILD.ntapi-0.3.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__parking_lot__0_11_2",
        url = "https://crates.io/api/v1/crates/parking_lot/0.11.2/download",
        type = "tar.gz",
        sha256 = "7d17b78036a60663b797adeaee46f5c9dfebb86948d1255007a1d6be0271ff99",
        strip_prefix = "parking_lot-0.11.2",
        build_file = Label("//cargo/remote:BUILD.parking_lot-0.11.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__parking_lot_core__0_8_5",
        url = "https://crates.io/api/v1/crates/parking_lot_core/0.8.5/download",
        type = "tar.gz",
        sha256 = "d76e8e1493bcac0d2766c42737f34458f1c8c50c0d23bcb24ea953affb273216",
        strip_prefix = "parking_lot_core-0.8.5",
        build_file = Label("//cargo/remote:BUILD.parking_lot_core-0.8.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__percent_encoding__2_1_0",
        url = "https://crates.io/api/v1/crates/percent-encoding/2.1.0/download",
        type = "tar.gz",
        sha256 = "d4fd5641d01c8f18a23da7b6fe29298ff4b55afcccdf78973b24cf3175fee32e",
        strip_prefix = "percent-encoding-2.1.0",
        build_file = Label("//cargo/remote:BUILD.percent-encoding-2.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__phf__0_10_1",
        url = "https://crates.io/api/v1/crates/phf/0.10.1/download",
        type = "tar.gz",
        sha256 = "fabbf1ead8a5bcbc20f5f8b939ee3f5b0f6f281b6ad3468b84656b658b455259",
        strip_prefix = "phf-0.10.1",
        build_file = Label("//cargo/remote:BUILD.phf-0.10.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__phf_shared__0_10_0",
        url = "https://crates.io/api/v1/crates/phf_shared/0.10.0/download",
        type = "tar.gz",
        sha256 = "b6796ad771acdc0123d2a88dc428b5e38ef24456743ddb1744ed628f9815c096",
        strip_prefix = "phf_shared-0.10.0",
        build_file = Label("//cargo/remote:BUILD.phf_shared-0.10.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__pin_project_lite__0_2_8",
        url = "https://crates.io/api/v1/crates/pin-project-lite/0.2.8/download",
        type = "tar.gz",
        sha256 = "e280fbe77cc62c91527259e9442153f4688736748d24660126286329742b4c6c",
        strip_prefix = "pin-project-lite-0.2.8",
        build_file = Label("//cargo/remote:BUILD.pin-project-lite-0.2.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__pin_utils__0_1_0",
        url = "https://crates.io/api/v1/crates/pin-utils/0.1.0/download",
        type = "tar.gz",
        sha256 = "8b870d8c151b6f2fb93e84a13146138f05d02ed11c7e7c54f8826aaaf7c9f184",
        strip_prefix = "pin-utils-0.1.0",
        build_file = Label("//cargo/remote:BUILD.pin-utils-0.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__postgres__0_19_2",
        url = "https://crates.io/api/v1/crates/postgres/0.19.2/download",
        type = "tar.gz",
        sha256 = "eb76d6535496f633fa799bb872ffb4790e9cbdedda9d35564ca0252f930c0dd5",
        strip_prefix = "postgres-0.19.2",
        build_file = Label("//cargo/remote:BUILD.postgres-0.19.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__postgres_protocol__0_6_3",
        url = "https://crates.io/api/v1/crates/postgres-protocol/0.6.3/download",
        type = "tar.gz",
        sha256 = "79ec03bce71f18b4a27c4c64c6ba2ddf74686d69b91d8714fb32ead3adaed713",
        strip_prefix = "postgres-protocol-0.6.3",
        build_file = Label("//cargo/remote:BUILD.postgres-protocol-0.6.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__postgres_types__0_2_2",
        url = "https://crates.io/api/v1/crates/postgres-types/0.2.2/download",
        type = "tar.gz",
        sha256 = "04619f94ba0cc80999f4fc7073607cb825bc739a883cb6d20900fc5e009d6b0d",
        strip_prefix = "postgres-types-0.2.2",
        build_file = Label("//cargo/remote:BUILD.postgres-types-0.2.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__ppv_lite86__0_2_16",
        url = "https://crates.io/api/v1/crates/ppv-lite86/0.2.16/download",
        type = "tar.gz",
        sha256 = "eb9f9e6e233e5c4a35559a617bf40a4ec447db2e84c20b55a6f83167b7e57872",
        strip_prefix = "ppv-lite86-0.2.16",
        build_file = Label("//cargo/remote:BUILD.ppv-lite86-0.2.16.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__proc_macro2__1_0_36",
        url = "https://crates.io/api/v1/crates/proc-macro2/1.0.36/download",
        type = "tar.gz",
        sha256 = "c7342d5883fbccae1cc37a2353b09c87c9b0f3afd73f5fb9bba687a1f733b029",
        strip_prefix = "proc-macro2-1.0.36",
        build_file = Label("//cargo/remote:BUILD.proc-macro2-1.0.36.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__quote__1_0_15",
        url = "https://crates.io/api/v1/crates/quote/1.0.15/download",
        type = "tar.gz",
        sha256 = "864d3e96a899863136fc6e99f3d7cae289dafe43bf2c5ac19b70df7210c0a145",
        strip_prefix = "quote-1.0.15",
        build_file = Label("//cargo/remote:BUILD.quote-1.0.15.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rand__0_8_4",
        url = "https://crates.io/api/v1/crates/rand/0.8.4/download",
        type = "tar.gz",
        sha256 = "2e7573632e6454cf6b99d7aac4ccca54be06da05aca2ef7423d22d27d4d4bcd8",
        strip_prefix = "rand-0.8.4",
        build_file = Label("//cargo/remote:BUILD.rand-0.8.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rand_chacha__0_3_1",
        url = "https://crates.io/api/v1/crates/rand_chacha/0.3.1/download",
        type = "tar.gz",
        sha256 = "e6c10a63a0fa32252be49d21e7709d4d4baf8d231c2dbce1eaa8141b9b127d88",
        strip_prefix = "rand_chacha-0.3.1",
        build_file = Label("//cargo/remote:BUILD.rand_chacha-0.3.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rand_core__0_6_3",
        url = "https://crates.io/api/v1/crates/rand_core/0.6.3/download",
        type = "tar.gz",
        sha256 = "d34f1408f55294453790c48b2f1ebbb1c5b4b7563eb1f418bcfcfdbb06ebb4e7",
        strip_prefix = "rand_core-0.6.3",
        build_file = Label("//cargo/remote:BUILD.rand_core-0.6.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rand_hc__0_3_1",
        url = "https://crates.io/api/v1/crates/rand_hc/0.3.1/download",
        type = "tar.gz",
        sha256 = "d51e9f596de227fda2ea6c84607f5558e196eeaf43c986b724ba4fb8fdf497e7",
        strip_prefix = "rand_hc-0.3.1",
        build_file = Label("//cargo/remote:BUILD.rand_hc-0.3.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__redox_syscall__0_2_10",
        url = "https://crates.io/api/v1/crates/redox_syscall/0.2.10/download",
        type = "tar.gz",
        sha256 = "8383f39639269cde97d255a32bdb68c047337295414940c68bdd30c2e13203ff",
        strip_prefix = "redox_syscall-0.2.10",
        build_file = Label("//cargo/remote:BUILD.redox_syscall-0.2.10.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__scopeguard__1_1_0",
        url = "https://crates.io/api/v1/crates/scopeguard/1.1.0/download",
        type = "tar.gz",
        sha256 = "d29ab0c6d3fc0ee92fe66e2d99f700eab17a8d57d1c1d3b748380fb20baa78cd",
        strip_prefix = "scopeguard-1.1.0",
        build_file = Label("//cargo/remote:BUILD.scopeguard-1.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__sha2__0_10_1",
        url = "https://crates.io/api/v1/crates/sha2/0.10.1/download",
        type = "tar.gz",
        sha256 = "99c3bd8169c58782adad9290a9af5939994036b76187f7b4f0e6de91dbbfc0ec",
        strip_prefix = "sha2-0.10.1",
        build_file = Label("//cargo/remote:BUILD.sha2-0.10.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__siphasher__0_3_9",
        url = "https://crates.io/api/v1/crates/siphasher/0.3.9/download",
        type = "tar.gz",
        sha256 = "a86232ab60fa71287d7f2ddae4a7073f6b7aac33631c3015abb556f08c6d0a3e",
        strip_prefix = "siphasher-0.3.9",
        build_file = Label("//cargo/remote:BUILD.siphasher-0.3.9.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__slab__0_4_5",
        url = "https://crates.io/api/v1/crates/slab/0.4.5/download",
        type = "tar.gz",
        sha256 = "9def91fd1e018fe007022791f865d0ccc9b3a0d5001e01aabb8b40e46000afb5",
        strip_prefix = "slab-0.4.5",
        build_file = Label("//cargo/remote:BUILD.slab-0.4.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__smallvec__0_4_5",
        url = "https://crates.io/api/v1/crates/smallvec/0.4.5/download",
        type = "tar.gz",
        sha256 = "f90c5e5fe535e48807ab94fc611d323935f39d4660c52b26b96446a7b33aef10",
        strip_prefix = "smallvec-0.4.5",
        build_file = Label("//cargo/remote:BUILD.smallvec-0.4.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__smallvec__1_8_0",
        url = "https://crates.io/api/v1/crates/smallvec/1.8.0/download",
        type = "tar.gz",
        sha256 = "f2dd574626839106c320a323308629dcb1acfc96e32a8cba364ddc61ac23ee83",
        strip_prefix = "smallvec-1.8.0",
        build_file = Label("//cargo/remote:BUILD.smallvec-1.8.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__smawk__0_3_1",
        url = "https://crates.io/api/v1/crates/smawk/0.3.1/download",
        type = "tar.gz",
        sha256 = "f67ad224767faa3c7d8b6d91985b78e70a1324408abcb1cfcc2be4c06bc06043",
        strip_prefix = "smawk-0.3.1",
        build_file = Label("//cargo/remote:BUILD.smawk-0.3.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__socket2__0_4_4",
        url = "https://crates.io/api/v1/crates/socket2/0.4.4/download",
        type = "tar.gz",
        sha256 = "66d72b759436ae32898a2af0a14218dbf55efde3feeb170eb623637db85ee1e0",
        strip_prefix = "socket2-0.4.4",
        build_file = Label("//cargo/remote:BUILD.socket2-0.4.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__stringprep__0_1_2",
        url = "https://crates.io/api/v1/crates/stringprep/0.1.2/download",
        type = "tar.gz",
        sha256 = "8ee348cb74b87454fff4b551cbf727025810a004f88aeacae7f85b87f4e9a1c1",
        strip_prefix = "stringprep-0.1.2",
        build_file = Label("//cargo/remote:BUILD.stringprep-0.1.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__subtle__2_4_1",
        url = "https://crates.io/api/v1/crates/subtle/2.4.1/download",
        type = "tar.gz",
        sha256 = "6bdef32e8150c2a081110b42772ffe7d7c9032b606bc226c8260fd97e0976601",
        strip_prefix = "subtle-2.4.1",
        build_file = Label("//cargo/remote:BUILD.subtle-2.4.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__syn__1_0_86",
        url = "https://crates.io/api/v1/crates/syn/1.0.86/download",
        type = "tar.gz",
        sha256 = "8a65b3f4ffa0092e9887669db0eae07941f023991ab58ea44da8fe8e2d511c6b",
        strip_prefix = "syn-1.0.86",
        build_file = Label("//cargo/remote:BUILD.syn-1.0.86.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__textwrap__0_13_4",
        url = "https://crates.io/api/v1/crates/textwrap/0.13.4/download",
        type = "tar.gz",
        sha256 = "cd05616119e612a8041ef58f2b578906cc2531a6069047ae092cfb86a325d835",
        strip_prefix = "textwrap-0.13.4",
        build_file = Label("//cargo/remote:BUILD.textwrap-0.13.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tinyvec__1_5_1",
        url = "https://crates.io/api/v1/crates/tinyvec/1.5.1/download",
        type = "tar.gz",
        sha256 = "2c1c1d5a42b6245520c249549ec267180beaffcc0615401ac8e31853d4b6d8d2",
        strip_prefix = "tinyvec-1.5.1",
        build_file = Label("//cargo/remote:BUILD.tinyvec-1.5.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tinyvec_macros__0_1_0",
        url = "https://crates.io/api/v1/crates/tinyvec_macros/0.1.0/download",
        type = "tar.gz",
        sha256 = "cda74da7e1a664f795bb1f8a87ec406fb89a02522cf6e50620d016add6dbbf5c",
        strip_prefix = "tinyvec_macros-0.1.0",
        build_file = Label("//cargo/remote:BUILD.tinyvec_macros-0.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio__1_16_1",
        url = "https://crates.io/api/v1/crates/tokio/1.16.1/download",
        type = "tar.gz",
        sha256 = "0c27a64b625de6d309e8c57716ba93021dccf1b3b5c97edd6d3dd2d2135afc0a",
        strip_prefix = "tokio-1.16.1",
        build_file = Label("//cargo/remote:BUILD.tokio-1.16.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_postgres__0_7_5",
        url = "https://crates.io/api/v1/crates/tokio-postgres/0.7.5/download",
        type = "tar.gz",
        sha256 = "4b6c8b33df661b548dcd8f9bf87debb8c56c05657ed291122e1188698c2ece95",
        strip_prefix = "tokio-postgres-0.7.5",
        build_file = Label("//cargo/remote:BUILD.tokio-postgres-0.7.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_util__0_6_9",
        url = "https://crates.io/api/v1/crates/tokio-util/0.6.9/download",
        type = "tar.gz",
        sha256 = "9e99e1983e5d376cd8eb4b66604d2e99e79f5bd988c3055891dcd8c9e2604cc0",
        strip_prefix = "tokio-util-0.6.9",
        build_file = Label("//cargo/remote:BUILD.tokio-util-0.6.9.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__typenum__1_15_0",
        url = "https://crates.io/api/v1/crates/typenum/1.15.0/download",
        type = "tar.gz",
        sha256 = "dcf81ac59edc17cc8697ff311e8f5ef2d99fcbd9817b34cec66f90b6c3dfd987",
        strip_prefix = "typenum-1.15.0",
        build_file = Label("//cargo/remote:BUILD.typenum-1.15.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__unicode_bidi__0_3_7",
        url = "https://crates.io/api/v1/crates/unicode-bidi/0.3.7/download",
        type = "tar.gz",
        sha256 = "1a01404663e3db436ed2746d9fefef640d868edae3cceb81c3b8d5732fda678f",
        strip_prefix = "unicode-bidi-0.3.7",
        build_file = Label("//cargo/remote:BUILD.unicode-bidi-0.3.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__unicode_normalization__0_1_19",
        url = "https://crates.io/api/v1/crates/unicode-normalization/0.1.19/download",
        type = "tar.gz",
        sha256 = "d54590932941a9e9266f0832deed84ebe1bf2e4c9e4a3554d393d18f5e854bf9",
        strip_prefix = "unicode-normalization-0.1.19",
        build_file = Label("//cargo/remote:BUILD.unicode-normalization-0.1.19.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__unicode_width__0_1_9",
        url = "https://crates.io/api/v1/crates/unicode-width/0.1.9/download",
        type = "tar.gz",
        sha256 = "3ed742d4ea2bd1176e236172c8429aaf54486e7ac098db29ffe6529e0ce50973",
        strip_prefix = "unicode-width-0.1.9",
        build_file = Label("//cargo/remote:BUILD.unicode-width-0.1.9.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__unicode_xid__0_2_2",
        url = "https://crates.io/api/v1/crates/unicode-xid/0.2.2/download",
        type = "tar.gz",
        sha256 = "8ccb82d61f80a663efe1f787a51b16b5a51e3314d6ac365b08639f52387b33f3",
        strip_prefix = "unicode-xid-0.2.2",
        build_file = Label("//cargo/remote:BUILD.unicode-xid-0.2.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__version_check__0_9_4",
        url = "https://crates.io/api/v1/crates/version_check/0.9.4/download",
        type = "tar.gz",
        sha256 = "49874b5167b65d7193b8aba1567f5c7d93d001cafc34600cee003eda787e483f",
        strip_prefix = "version_check-0.9.4",
        build_file = Label("//cargo/remote:BUILD.version_check-0.9.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__wasi__0_10_2_wasi_snapshot_preview1",
        url = "https://crates.io/api/v1/crates/wasi/0.10.2+wasi-snapshot-preview1/download",
        type = "tar.gz",
        sha256 = "fd6fbd9a79829dd1ad0cc20627bf1ed606756a7f77edff7b66b7064f9cb327c6",
        strip_prefix = "wasi-0.10.2+wasi-snapshot-preview1",
        build_file = Label("//cargo/remote:BUILD.wasi-0.10.2+wasi-snapshot-preview1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__winapi__0_3_9",
        url = "https://crates.io/api/v1/crates/winapi/0.3.9/download",
        type = "tar.gz",
        sha256 = "5c839a674fcd7a98952e593242ea400abe93992746761e38641405d28b00f419",
        strip_prefix = "winapi-0.3.9",
        build_file = Label("//cargo/remote:BUILD.winapi-0.3.9.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__winapi_i686_pc_windows_gnu__0_4_0",
        url = "https://crates.io/api/v1/crates/winapi-i686-pc-windows-gnu/0.4.0/download",
        type = "tar.gz",
        sha256 = "ac3b87c63620426dd9b991e5ce0329eff545bccbbb34f3be09ff6fb6ab51b7b6",
        strip_prefix = "winapi-i686-pc-windows-gnu-0.4.0",
        build_file = Label("//cargo/remote:BUILD.winapi-i686-pc-windows-gnu-0.4.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__winapi_x86_64_pc_windows_gnu__0_4_0",
        url = "https://crates.io/api/v1/crates/winapi-x86_64-pc-windows-gnu/0.4.0/download",
        type = "tar.gz",
        sha256 = "712e227841d057c1ee1cd2fb22fa7e5a5461ae8e48fa2ca79ec42cfc1931183f",
        strip_prefix = "winapi-x86_64-pc-windows-gnu-0.4.0",
        build_file = Label("//cargo/remote:BUILD.winapi-x86_64-pc-windows-gnu-0.4.0.bazel"),
    )
