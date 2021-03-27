#!/bin/bash

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == 1 ]]; then
  pushd build-host
    cp bin/mlir-linalg-ods-gen bin/mlir-tblgen ${BUILD_PREFIX}/bin
  popd
fi

cd build
make install
