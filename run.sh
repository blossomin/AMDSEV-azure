#!/bin/bash

set -ex

docker build --build-arg UBUNTU_VERSION=22.04 -t amdsev-build:22.04 docker/

run2204() {
  docker run --init --rm -v $PWD/.ccache:/root/.ccache -v $PWD:$PWD -w $PWD amdsev-build:22.04 "$@"
}

run2204 ./build.sh qemu
run2204 ./build.sh ovmf
run2204 ./build.sh --package kernel guest

run2204 ./repack.sh
