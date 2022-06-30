import "rt"

fun append(s: in out string, what: string) = do
    for range 0, what.len do |i|
        append(s, what[i])
    end
end

fun main = do
    let testdirs = {
        "test-001-arith",
        "test-002-arrays",
        "test-003-for",
        "test-004-boolops",
        "test-005-nil",
        "test-006-strings",
        "test-007-pointers",
        "test-008-funcs",
        "test-009-enums",
        "test-010-bitwise",
        "test-011-defer",
        "test-012-field",
        "test-013-index",
        "test-014-init",
        "test-015-falsevalues",
        "test-016-macros",
        "test-017-placeholder",
        "test-018-stat",
        "test-019-errorstrings",
        "test-020-readfile",
        "test-021-aoc2021-01",
        "test-022-arraydyncast",
        "test-023-rule110",
        "test-024-exec",
        "test-025-compute",
    }
    let ok_count = 0

    let start = 0

    let args = arguments()
    if args.len > 1 then
        discard parse_int(args[1], 10, start)
    end

    for range 0, testdirs.len do |i|
        if i < start then continue end

        let dirname = testdirs[i]

        let fullpath : string
        append(fullpath, "../tests/")
        append(fullpath, dirname)
        chdir(fullpath)

        putln("Running: ", fullpath)

        let code : int
        let err = exec(
            COMPILER_PATH,
            {"-p", "../..", "-I", "runtime/linux", "-V", "-o", "a.out"},
            code
        )
        if err or code /= 0 then
            putln("Error: ", fullpath, " ", err, " exit code: ", code)
        else
            putln("Success: ", fullpath)
            ok_count = _ + 1
        end

        chdir("../../test-runner")
    end

    putln("Finished tests: ", ok_count, " out of ", testdirs.len, " passed!")
end