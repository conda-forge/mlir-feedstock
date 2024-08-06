#!/bin/bash
set -euxo pipefail

PARALLEL=""
if [[ "${target_platform}" == "linux-ppc64le" ]]; then
  export CFLAGS="${CFLAGS//-fno-plt/}"
  export CXXFLAGS="${CXXFLAGS//-fno-plt/}"
elif [[ "${target_platform}" == "linux-aarch64" ]]; then
  # reduce parallelism on aarch to avoid OOM
  PARALLEL="-j2"
elif [[ "${target_platform}" == osx-* ]]; then
  CMAKE_ARGS="$CMAKE_ARGS -DLLVM_ENABLE_LIBCXX=ON"
fi

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  CMAKE_ARGS="${CMAKE_ARGS} -DLLVM_TABLEGEN_EXE=$BUILD_PREFIX/bin/llvm-tblgen -DNATIVE_LLVM_DIR=$BUILD_PREFIX/lib/cmake/llvm"
  NATIVE_FLAGS="-DCMAKE_C_COMPILER=$CC_FOR_BUILD;-DCMAKE_CXX_COMPILER=$CXX_FOR_BUILD"
  NATIVE_FLAGS="${NATIVE_FLAGS};-DCMAKE_C_FLAGS=-O2;-DCMAKE_CXX_FLAGS=-O2"
  NATIVE_FLAGS="${NATIVE_FLAGS};-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,${BUILD_PREFIX}/lib"
  NATIVE_FLAGS="${NATIVE_FLAGS};-DCMAKE_MODULE_LINKER_FLAGS=;-DCMAKE_SHARED_LINKER_FLAGS="
  NATIVE_FLAGS="${NATIVE_FLAGS};-DCMAKE_STATIC_LINKER_FLAGS=;-DCMAKE_PREFIX_PATH=${BUILD_PREFIX}"
  CMAKE_ARGS="${CMAKE_ARGS} -DCROSS_TOOLCHAIN_FLAGS_NATIVE=${NATIVE_FLAGS}"
else
  rm -rf $BUILD_PREFIX/bin/llvm-tblgen
fi

mkdir -p build
cd build

cmake ${CMAKE_ARGS} \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_BUILD_LLVM_DYLIB=ON \
  -DLLVM_LINK_LLVM_DYLIB=ON \
  -DLLVM_BUILD_TOOLS=ON \
  -DLLVM_BUILD_UTILS=ON \
  -GNinja \
  ../mlir

ninja ${PARALLEL}
