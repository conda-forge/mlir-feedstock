#!/bin/bash

source $RECIPE_DIR/build.sh

ninja install
mkdir -p $SP_DIR
mv $PREFIX/python_packages/mlir_core/mlir $SP_DIR/
rm -rf $PREFIX/src
