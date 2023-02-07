#!/bin/bash

set -uxo pipefail

if [[ "${target_platform}" == "linux-ppc64le" ]]; then
  export CFLAGS="${CFLAGS//-fno-plt/}"
  export CXXFLAGS="${CXXFLAGS//-fno-plt/}"
fi

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  # Can't have llvmdev in BUILD_PREFIX as llvmdev conflicts with the clang compiler
  # TODO: remove conflict between llvmdev and clang compiler
  conda create -p $BUILD_PREFIX/llvm llvmdev=$PKG_VERSION --yes --quiet
  CMAKE_ARGS="${CMAKE_ARGS} -DLLVM_TABLEGEN_EXE=$BUILD_PREFIX/llvm/bin/llvm-tblgen -DNATIVE_LLVM_DIR=$BUILD_PREFIX/llvm/lib/cmake/llvm"
  CMAKE_ARGS="${CMAKE_ARGS} -DCROSS_TOOLCHAIN_FLAGS_NATIVE=-DCMAKE_C_COMPILER=$CC_FOR_BUILD;-DCMAKE_CXX_COMPILER=$CXX_FOR_BUILD;-DCMAKE_C_FLAGS=-O2;-DCMAKE_CXX_FLAGS=-O2;-DCMAKE_EXE_LINKER_FLAGS=\"-L$BUILD_PREFIX/lib\";-DCMAKE_MODULE_LINKER_FLAGS=;-DCMAKE_SHARED_LINKER_FLAGS=;-DCMAKE_STATIC_LINKER_FLAGS=;-DCMAKE_AR=$(which ${AR});-DCMAKE_RANLIB=$(which ${RANLIB});-DZLIB_ROOT=${BUILD_PREFIX}"
else
  rm -rf $BUILD_PREFIX/bin/llvm-tblgen
fi

if [[ "${PKG_NAME}" == "mlir-python-bindings" ]]; then
  CMAKE_ARGS="${CMAKE_ARGS} -DMLIR_ENABLE_BINDINGS_PYTHON=ON -DPython3_EXECUTABLE=$PYTHON"
  if [[ -f "build/CMakeCache.txt" ]]; then
	# invalidate the cache as we are building multiple times for different python versions
    sed -i.bak "/^_Python3_INTERPRETER_PROPERTIES/d" build/CMakeCache.txt
  fi
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

ninja
