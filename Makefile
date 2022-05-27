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

	@echo "test-02-arrays: ..." && \
		cd tests/test-02-arrays && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-02-arrays: OK\033[0m"

	@echo "test-03-for: ..." && \
		cd tests/test-03-for && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-03-for: OK\033[0m"

	@echo "test-04-boolops: ..." && \
		cd tests/test-04-boolops && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-04-boolops: OK\033[0m"

	@echo "test-05-nil: ..." && \
		cd tests/test-05-nil && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-05-nil: OK\033[0m"

	@echo "test-06-strings: ..." && \
		cd tests/test-06-strings && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-06-strings: OK\033[0m"

	@echo "test-07-pointers: ..." && \
		cd tests/test-07-pointers && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-07-pointers: OK\033[0m"

	@echo "test-08-funcs: ..." && \
		cd tests/test-08-funcs && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-08-funcs: OK\033[0m"

	@echo "test-09-enums: ..." && \
		cd tests/test-09-enums && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-09-enums: OK\033[0m"

	@echo "test-10-bitwise: ..." && \
		cd tests/test-10-bitwise && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-10-bitwise: OK\033[0m"

	@echo "test-11-rule110: ..." && \
		cd tests/test-11-rule110 && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-11-rule110: OK\033[0m"

	@echo "test-12-field: ..." && \
		cd tests/test-12-field && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-12-field: OK\033[0m"

	@echo "test-13-index: ..." && \
		cd tests/test-13-index && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-13-index: OK\033[0m"

	@echo "test-14-init: ..." && \
		cd tests/test-14-init && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-14-init: OK\033[0m"

	@echo "test-15-falsevalues: ..." && \
		cd tests/test-15-falsevalues && \
		carbonc -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-15-falsevalues: OK\033[0m"

.PHONY: all