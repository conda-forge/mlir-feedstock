#!/bin/bash
set -x -e

cd ${SRC_DIR}/build
make install

cd $PREFIX
rm -rf libexec share bin include
mv lib lib2
mkdir lib
cp lib2/libLLVM* lib/
if [[ "$PKG_NAME" == "libmlir" ]]; then
    cp lib2/libMLIR${SHLIB_EXT} lib/
else
    cp lib2/libMLIR.*.* lib/
fi
rm -rf lib2

