# Python

You can install Python with:

```shell
wapm install python
```

## Running 

### From WAPM

Run a locally python script in the `./lib` directory:

```
wasmer --net python/python --mapdir=/lib:./lib -- /lib/pythonfile.py
```

**Note:** this assumes you have a file named `./lib/pythonfile.py`.

### From Locally-built Binary

Follow the "Building from Source" instructions below, then:

```
BUILDDIR="$(PWD)/cpython/builddir-wasix-libc/wasi/"
wasmer --net $BUILDDIR/python.wasm --mapdir=/lib:./lib --mapdir=/usr:$BUILDDIR/usr -- /lib/pythonfile.py
```
**Note:** this assumes you have a file named `./lib/pythonfile.py`.

## Building from Source

### Dependencies

* GNU Make
* WASI SDK
* native C toolchain (eg. gcc or clang)

### Instructions

To download the WASI SDK and build cpython and its dependencies:

```
make wasi-sdk
make
```
