# Python

Python is an interpreted, high-level, general-purpose programming language. Created by Guido van Rossum and first released in 1991, Python's design philosophy emphasizes code readability with its notable use of significant whitespace.

You can install python with:

```shell
wapm install python
```

**Original Source**: https://github.com/python-cmake-buildsystem/python-cmake-buildsystem

**Modification**: The original code ported Python to CMake. We made some adaptations to use [`wasienv`](https://github.com/wasienv/wasienv) as the main compiler.


## Running

You can run the `python` shell:

```bash
$ wapm run python
Python 3.6.7 (default, Feb 14 2020, 03:17:48)
[Wasm WASI vClang 9.0.0 (https://github.com/llvm/llvm-project 0399d5a9682b3cef7 on generic
Type "help", "copyright", "credits" or "license" for more information.
>>>>>> this_is = "wapm"
>>> print(f"Hello from {this_is}")
Hello from wapm
>>>
```


## Building

The following script will install [`wasienv`](https://github.com/wasienv/wasienv) and build the Wasm binary.

```bash
./build.sh
```
