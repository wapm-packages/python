#!/bin/bash

# Install wasienv
# curl https://raw.githubusercontent.com/wasienv/wasienv/master/install.sh | sh

mkdir -p build
cd build
wasimake cmake -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/install ../..
make -j8
make install
cd ..

mkdir -p bin
mkdir -p lib
# Copy the python file
cp build/bin/python.wasm bin
cp -R build/install/lib lib

# Remove unnecessary files in the lib dir
find lib | grep -E "(__pycache__|test|\.pyc|\.pyo|\.whl$)" | xargs rm -rf\n
