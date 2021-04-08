#!/usr/bin/env sh

# Based on code from https://github.com/TrueBitFoundation/wasm-ports/blob/master/openssl.sh

OPENSSL_VERSION="master"
PREFIX=`pwd`

OPENSSL_DIRECTORY=`pwd`/OpenSSL-${OPENSSL_VERSION}


if [ ! -d "$OPENSSL_DIRECTORY" ]; then
  echo "Download curl source code"
  wget https://github.com/wapm-packages/OpenSSL/archive/refs/heads/${OPENSSL_VERSION}.tar.gz
  tar xf ${OPENSSL_VERSION}.tar.gz
fi

mkdir -p python-wasix/install
cd python-wasix
echo "Configure"
wasix-make cmake -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/install -DOPENSSL_INCLUDE_DIR:PATH=${OPENSSL_DIRECTORY}/include -DOPENSSL_ROOT_DIR=${OPENSSL_DIRECTORY} -DUSE_SYSTEM_OpenSSL=OFF -DOPENSSL_LIBRARIES=ssl\;crypto LDFLAGS="-Wl,-L${OPENSSL_DIRECTORY}/lib" ..

echo "Build"
make -j10

cp python-wasix/bin/python.wasm .

echo "Done"
