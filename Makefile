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
	@echo "test_arith: ..." && \
		cd tests/test_arith && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_arith: OK\033[0m"

	@echo "test_nil: ..." && \
		cd tests/test_nil && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_nil: OK\033[0m"

	@echo "test_boolops: ..." && \
		cd tests/test_boolops && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_boolops: OK\033[0m"

	@echo "test_for_loop: ..." && \
		cd tests/test_for_loop && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_for_loop: OK\033[0m"

	@echo "test_strings: ..." && \
		cd tests/test_strings && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_strings: OK\033[0m"

	@echo "test_error_strings: ..." && \
		cd tests/test_error_strings && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_error_strings: OK\033[0m"

	@echo "test_arrays: ..." && \
		cd tests/test_arrays && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_arrays: OK\033[0m"

	@echo "test_unpack: ..." && \
		cd tests/test_unpack && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_unpack: OK\033[0m"

	@echo "test_generic_funcs: ..." && \
		cd tests/test_generic_funcs && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_generic_funcs: OK\033[0m"

	@echo "test_rule110: ..." && \
		cd tests/test_rule110 && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_rule110: OK\033[0m"

	@echo "test_aoc01: ..." && \
		cd tests/test_aoc01 && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_aoc01: OK\033[0m"

	@echo "test_variables: ..." && \
		cd tests/test_variables && \
		carbonc -p ../.. -I stdlib -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest_variables: OK\033[0m"

.PHONY: all
