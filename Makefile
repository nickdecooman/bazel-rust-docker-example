gen-project:
	bazel run @rules_rust//tools/rust_analyzer:gen_rust_project

raze:
	cargo raze

bazel/output-all-labels:
	bazel query //... --output label_kind
