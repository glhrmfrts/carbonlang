VERSION=$(shell git describe --tags)

CMAKE_VARS=-DCARBON_VERSION=$(VERSION)

BUILD_DIR=build_linux

gen:
	cmake . -B $(BUILD_DIR) $(CMAKE_VARS)

build: gen
	cd $(BUILD_DIR) && make -j5

install: build
	install $(BUILD_DIR)/carbonc/carbonc -t /usr/bin/

test:
	@echo "test-01-arith: ..." && \
		cd tests/test-01-arith && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-01-arith: OK\033[0m"

.PHONY: all