#!/bin/bash
set -x -e

cd ${SRC_DIR}/build
ninja install

cd $PREFIX
rm -rf libexec share bin include
mv lib lib2
mkdir lib
cp lib2/libLLVM* lib/
if [[ "$PKG_NAME" == "libmlir" ]]; then
    cp lib2/libMLIR${SHLIB_EXT} lib/
    cp lib2/libmlir_runner_utils${SHLIB_EXT} lib/
    cp lib2/libmlir_c_runner_utils${SHLIB_EXT} lib/
    cp lib2/libmlir_async_runtime${SHLIB_EXT} lib/
elif [[ "$PKG_NAME" == "mlir-python-bindings" ]]; then
    mkdir -p $SP_DIR
    mv $PREFIX/python_packages/mlir_core/mlir $SP_DIR/
else
    cp lib2/libMLIR.*.* lib/
    cp lib2/libmlir_runner_utils.*.* lib/
    cp lib2/libmlir_c_runner_utils.*.* lib/
    cp lib2/libmlir_async_runtime.*.* lib/
fi
rm -rf lib2 $PREFIX/src $PREFIX/python_packages

