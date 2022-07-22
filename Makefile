VERSION=$(shell git describe --tags)
COMPILER_NAME=pardalc
INSTALL_DIR=/usr

CMAKE_VARS=-DCOMPILER_VERSION=$(VERSION) -DCOMPILER_NAME=$(COMPILER_NAME)

BUILD_DIR=build_linux

gen:
	cmake . -B $(BUILD_DIR) $(CMAKE_VARS)

build: gen
	cd $(BUILD_DIR) && make -j5

install: build
	install $(BUILD_DIR)/compiler/$(COMPILER_NAME) -t $(INSTALL_DIR)/bin

CURRENT_TEST=tests/test-022-arraydyncast

com:
	cd $(CURRENT_TEST) && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out

run:
	cd $(CURRENT_TEST) && ./a.out

runner:
	@cd test-runner && $(COMPILER_NAME) -p .. -I runtime/linux -o a.out && ./a.out

test:
	@echo "test-001-arith: ..." && \
		cd tests/test-001-arith && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-001-arith: OK\033[0m"

	@echo "test-002-arrays: ..." && \
		cd tests/test-002-arrays && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-002-arrays: OK\033[0m"

	@echo "test-003-for: ..." && \
		cd tests/test-003-for && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-003-for: OK\033[0m"

	@echo "test-004-boolops: ..." && \
		cd tests/test-004-boolops && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-004-boolops: OK\033[0m"

	@echo "test-005-nil: ..." && \
		cd tests/test-005-nil && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-005-nil: OK\033[0m"

	@echo "test-006-strings: ..." && \
		cd tests/test-006-strings && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-006-strings: OK\033[0m"

	@echo "test-007-pointers: ..." && \
		cd tests/test-007-pointers && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-007-pointers: OK\033[0m"

	@echo "test-008-funcs: ..." && \
		cd tests/test-008-funcs && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-008-funcs: OK\033[0m"

	@echo "test-009-enums: ..." && \
		cd tests/test-009-enums && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-009-enums: OK\033[0m"

	@echo "test-010-bitwise: ..." && \
		cd tests/test-010-bitwise && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-010-bitwise: OK\033[0m"

	@echo "test-011-defer: ..." && \
		cd tests/test-011-defer && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-011-defer: OK\033[0m"

	@echo "test-012-field: ..." && \
		cd tests/test-012-field && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-012-field: OK\033[0m"

	@echo "test-013-index: ..." && \
		cd tests/test-013-index && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-013-index: OK\033[0m"

	@echo "test-014-init: ..." && \
		cd tests/test-014-init && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-014-init: OK\033[0m"

	@echo "test-015-falsevalues: ..." && \
		cd tests/test-015-falsevalues && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-015-falsevalues: OK\033[0m"

	@echo "test-016-macros: ..." && \
		cd tests/test-016-macros && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-016-macros: OK\033[0m"

	@echo "test-017-placeholder: ..." && \
		cd tests/test-017-placeholder && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-017-placeholder: OK\033[0m"

	@echo "test-018-errorstrings: ..." && \
		cd tests/test-018-errorstrings && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-018-errorstrings: OK\033[0m"

	@echo "test-019-stat: ..." && \
		cd tests/test-019-stat && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-019-stat: OK\033[0m"

	@echo "test-020-readfile: ..." && \
		cd tests/test-020-readfile && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-020-readfile: OK\033[0m"

	@echo "test-021-aoc2021-01: ..." && \
		cd tests/test-021-aoc2021-01 && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-021-aoc2021-01: OK\033[0m"

	@echo "test-022-arraydyncast: ..." && \
		cd tests/test-022-arraydyncast && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-022-arraydyncast: OK\033[0m"

	@echo "test-023-rule110: ..." && \
		cd tests/test-023-rule110 && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-023-rule110: OK\033[0m"

	@echo "test-024-exec: ..." && \
		cd tests/test-024-exec && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-024-exec: OK\033[0m"

	@echo "test-025-compute: ..." && \
		cd tests/test-025-compute && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-025-compute: OK\033[0m"

	@echo "test-026-undefined: ..." && \
		cd tests/test-026-undefined && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-026-undefined: OK\033[0m"

	@echo "test-027-errorhandling: ..." && \
		cd tests/test-027-errorhandling && \
		$(COMPILER_NAME) -p ../.. -I runtime/linux -V -o a.out > compile.txt && \
		./a.out > out.txt && diff out.txt expected.txt && echo "\033[1;32mtest-027-errorhandling: OK\033[0m"

.PHONY: all
