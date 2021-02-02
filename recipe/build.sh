mkdir build
cd build

cmake ${CMAKE_ARGS} \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_PREFIX_PATH="${PREFIX}" \
  -DLLVM_BUILD_LLVM_DYLIB=ON \
  -DLLVM_BUILD_LLVM_DYLIB=ON \
  ../mlir

make -j${CPU_COUNT}
