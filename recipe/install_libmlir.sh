#!/bin/bash
set -x -e

# temporary prefix to be able to install files more granularly
mkdir temp_prefix
cmake --install ./build --prefix=./temp_prefix

if [[ "$PKG_NAME" == "libmlir" ]]; then
    cp ./temp_prefix/lib/libMLIR${SHLIB_EXT} $PREFIX/lib/
    cp ./temp_prefix/lib/libmlir_async_runtime${SHLIB_EXT} $PREFIX/lib/
    cp ./temp_prefix/lib/libmlir_c_runner_utils${SHLIB_EXT} $PREFIX/lib/
    cp ./temp_prefix/lib/libmlir_float16_utils${SHLIB_EXT} $PREFIX/lib/
    cp ./temp_prefix/lib/libmlir_runner_utils${SHLIB_EXT} $PREFIX/lib/
else
    cp ./temp_prefix/lib/libMLIR.*.* $PREFIX/lib/
    cp ./temp_prefix/lib/libmlir_async_runtime.*.* $PREFIX/lib/
    cp ./temp_prefix/lib/libmlir_c_runner_utils.*.* $PREFIX/lib/
    cp ./temp_prefix/lib/libmlir_float16_utils.*.* $PREFIX/lib/
    cp ./temp_prefix/lib/libmlir_runner_utils.*.* $PREFIX/lib/
fi

# clean up between builds
rm -rf ./temp_prefix
