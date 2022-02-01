build:
	bazel build //service1:app

build_release:
	bazel build //service1:app --//:release

run:
	bazel run //service1:app

docker/build:
	bazel build //service1:image --platforms //build/platform:musl --//:release

docker/run:
	bazel run //service1:image --platforms //build/platform:musl --//:release

docker/publish:
	bazel run //service1:publish --platforms //build/platform:musl --//:release
