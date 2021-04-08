# Python

You can install Python with:

```shell
wapm install python
```

## Running

You can run Python cli

```shell
$ wasmer python.wasm --mapdir=lib:lib -- pythonfile.py
```

## Building from Source

You will need [Wasix](https://github.com/wasmer/wasix) to build the `python.wasm` file.


Steps:

1. Setup wasix, see
   [Installation Instructions](https://github.com/wasmerio/wasix)
2. Run `./build.sh`
