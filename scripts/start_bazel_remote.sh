#! /bin/bash

set -o errexit
set -o nounset
set -o pipefail

bazel-remote \
  --dir ~/.bazelcache \
  --http_address localhost:9090 \
  --max_size 1 \
  --s3.endpoint s3.$AWS_REGION.amazonaws.com \
  --s3.auth_method access_key \
  --s3.access_key_id $AWS_ACCESS_KEY_ID \
  --s3.secret_access_key $AWS_SECRET_ACCESS_KEY \
  --s3.bucket $AWS_S3_BUCKET_BAZEL_CACHE
