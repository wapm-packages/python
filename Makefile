CPYTHON_DIR = $(PWD)/cpython
WASMERIO_DIR = $(basename $(PWD))
WASIXLIBC_DIR = $(PWD)/libs/wasix-libc
ZLIB_DIR = $(PWD)/libs/zlib
BUILD_DIR = $(PWD)/builddir
DOWNLOADS_DIR = $(PWD)/downloads
WAPM_DIR = $(PWD)/wapm

# used by cpython's wasm build scripts
export WASI_SDK_PATH = $(PWD)/wasi-sdk
export WASI_SYSROOT = $(BUILD_DIR)/sysroot
export WASI_SYSROOT_LIBDIR = $(WASI_SYSROOT)/lib/wasm32-wasi
export WASM_RUNTIME = wasmer
# BUILDDIR is used by $(CPYTHON_DIR)/Tools/wasm/wasm_build.py, not to be
# confused with BUILD_DIR
export BUILDDIR = $(CPYTHON_DIR)/builddir
export PYTHON_LIB_ZIP = $(BUILDDIR)/wasix/usr/local/lib/

WASI_SDK_VERSION_MAJOR = 20
WASI_SDK_VERSION_MINOR = 0
WASI_SDK_BASE_URL = https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-$(WASI_SDK_VERSION_MAJOR)/
WASI_SDK_TARBALL = $(DOWNLOADS_DIR)/wasi-sdk-$(WASI_SDK_VERSION_MAJOR).$(WASI_SDK_VERSION_MINOR).tar.gz

# platform-specific setting
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	WASI_SDK_URL_PLATFORM = linux
endif
ifeq ($(UNAME_S),Darwin)
	WASI_SDK_URL_PLATFORM = macos
endif

WASI_SDK_URL = $(WASI_SDK_BASE_URL)/wasi-sdk-$(WASI_SDK_VERSION_MAJOR).$(WASI_SDK_VERSION_MINOR)-$(WASI_SDK_URL_PLATFORM).tar.gz

default: wasixlibc-build zlib-build python-build

vars:
	@@echo PWD = $(PWD)
	@@echo CPYTHON_DIR = $(CPYTHON_DIR)
	@@echo WASIXLIBC_DIR = $(WASIXLIBC_DIR)
	@@echo ZLIB_DIR = $(ZLIB_DIR)
	@@echo WASMERIO_DIR = $(WASMERIO_DIR)
	@@echo TARGET_ARCH = $(TARGET_ARCH)
	@@echo TARGET_OS = $(TARGET_OS)
	@@echo WASI_SDK_PATH = $(WASI_SDK_PATH)
	@@echo WASM_RUNTIME = $(WASM_RUNTIME)
	@@echo WASI_SYSROOT = $(WASI_SYSROOT)
	@@echo BUILD_DIR = $(BUILD_DIR)
	@@echo ZLIB_CFLAGS = $(ZLIB_CFLAGS)
	@@echo ZLIB_LIBS = $(ZLIB_LIBS)
	@@echo WASI_SDK_PATH = $(WASI_SDK_PATH)


clean: python-clean zlib-clean wasixlibc-clean

distclean: clean python-distclean
	rm -rf ./wasi-sdk*

##
#  wasix-libc bits
##
wasixlibc-build-clean: wasixlibc-build wasixlibc-clean
wasixlibc-build: export TARGET_ARCH=wasm32
wasixlibc-build: export TARGET_OS=wasix
wasixlibc-build: wasixlibc-clean
	$(MAKE) -C $(WASIXLIBC_DIR) -j 28 SYSROOT=$(WASI_SYSROOT)

wasixlibc-clean:
	$(MAKE) -C $(WASIXLIBC_DIR) clean SYSROOT=$(WASI_SYSROOT)
	rm -rf $(WASI_SYSROOT)

##
#  zlib bits
##
zlib-build-clean: zlib-clean zlib-build
zlib-build: export CC=$(WASI_SDK_PATH)/bin/clang
zlib-build: export RANLIB=$(WASI_SDK_PATH)/bin/ranlib
zlib-build: $(WASI_SDK_PATH)
	cd $(ZLIB_DIR) && ./configure \
	  --prefix=$(WASI_SYSROOT) \
	  --libdir=$(WASI_SYSROOT_LIBDIR)
	$(MAKE) -C $(ZLIB_DIR) libz.a RANLIB=$(RANLIB)
	$(MAKE) -C $(ZLIB_DIR) install prefix=$(WASI_SYSROOT) libdir=$(WASI_SYSROOT_LIBDIR)

zlib-clean:
	$(MAKE) -C $(ZLIB_DIR) distclean

##
#  python bits
##
python-build-clean: python-clean python-build

python-build: $(WASI_SDK_PATH)
	cd $(CPYTHON_DIR) && \
		./Tools/wasm/wasm_build.py wasix build && \
		./Tools/wasm/wasm_build.py wasix stdlib
	mv $(BUILDDIR)/wasix/python.wasm $(BUILDDIR)/wasix/python.wasm.unopt
	wasm-opt -O2 --asyncify \
		$(BUILDDIR)/wasix/python.wasm.unopt \
		-o $(BUILDDIR)/wasix/python.wasm


python-autoconf:
	docker run --rm \
		-w /cpython \
		-v $(PWD)/cpython:/cpython \
		autoconf2.69 \
		autoconf
	docker run --rm \
		-v $(PWD)/cpython:/cpython \
		autoconf2.69 \
		chown -R $(shell id -u):$(shell id -g) /cpython

python-distclean:
	rm -rf $(BUILDDIR)

python-clean:
	rm -rf \
		$(BUILDDIR)/wasix

unzip-stdlib:
	cd $(BUILDDIR)/wasix/usr/local/lib/python3.12 && \
		unzip ../python312.zip


##
# wasi-sdk bits
##
$(WASI_SDK_TARBALL):
	mkdir -p $(DOWNLOADS_DIR)
	wget $(WASI_SDK_URL) -O $@

$(WASI_SDK_PATH): $(WASI_SDK_TARBALL)
	mkdir -p $@
	tar -xzf $(WASI_SDK_TARBALL) \
		-C $@ \
		--strip-components 1

wasi-sdk: $(WASI_SDK_PATH)

.python-zip-name:
	wasmer run \
		--mapdir /usr:$(BUILDDIR)/wasix/usr \
		--mapdir /app/:$(CPYTHON_DIR)/PC/layout/support \
		$(BUILDDIR)/wasix/python.wasm \
		-- \
		-c "import app.constants as constants; print(constants.PYTHON_ZIP_NAME)" > $@

wapm: ZIP_FILE=$(BUILDDIR)/wasix/usr/local/lib/$(shell cat .python-zip-name)
wapm: .python-zip-name $(BUILDDIR)/wasix/python.wasm
	cp $(BUILDDIR)/wasix/python.wasm $(WAPM_DIR)/bin/python.wasm
	rm -rf $(WAPM_DIR)/usr/local/lib
	mkdir -p $(WAPM_DIR)/usr/local/lib
	cd $(WAPM_DIR)/usr/local/lib && \
		unzip $(ZIP_FILE)

.PHONY: vars wapm wasi-sdk clean distclean python-clean zlib-clean wasixlibc-clean
