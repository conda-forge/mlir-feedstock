#!/bin/bash

set -euxo pipefail

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == 1 ]]; then
  (
    mkdir -p build-host
    pushd build-host

    export CC=$CC_FOR_BUILD
    export CXX=$CXX_FOR_BUILD
    export LDFLAGS=${LDFLAGS//$PREFIX/$BUILD_PREFIX}

    # Unset them as we're ok with builds that are either slow or non-portable
    unset CFLAGS
    unset CXXFLAGS

    cmake .. \
      -DCMAKE_PREFIX_PATH=${BUILD_PREFIX} \
      -DLLVM_DIR=${BUILD_PREFIX} \
      ../mlir
    make -j${CPU_COUNT} mlir-tblgen mlir-linalg-ods-gen
    cp bin/mlir-linalg-ods-gen bin/mlir-tblgen ${BUILD_PREFIX}/bin
    popd
  )
  CMAKE_ARGS="$CMAKE_ARGS -DMLIR_TABLEGEN=$SRC_DIR/build-host/bin/mlir-tblgen"
fi

mkdir -p build
cd build

cmake ${CMAKE_ARGS} \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_BUILD_LLVM_DYLIB=ON \
  -DLLVM_BUILD_TOOLS=ON \
  ../mlir

make -j${CPU_COUNT}
