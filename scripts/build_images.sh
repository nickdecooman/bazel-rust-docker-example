#! /bin/bash

IMAGES=`bazel query "kind(_app_layer, //...)"`

for IMAGE in $IMAGES
do
	bazel build $IMAGE --config=ci
done
