#!/bin/bash

cd build
ninja install

rm -rf $PREFIX/src $PREFIX/python_packages
