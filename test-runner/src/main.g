import "rt"

fun append(s: in out string, what: string) = do
    for range 0, what.len do |i|
        append(s, what[i])
    end
end

fun main = do
    let COMPILER_PATH = "/usr/bin/carbonc"
    let testdirs = {
        "test-001-arith",
        "test-002-arrays",
        "test-003-for",
        "test-004-boolops",
        "test-005-nil",
        "test-006-strings",
        "test-007-pointers",
        "test-008-funcs",
    }
    for range 0, testdirs.len do |i|
        let dirname = testdirs[i]

        let fullpath : string
        append(fullpath, "../tests/")
        append(fullpath, dirname)
        chdir(fullpath)

        putln("Running: ", fullpath)

        let code : int
        let err = exec(COMPILER_PATH, {"-p", "../..", "-I", "runtime/linux", "-V", "-o", "a.out"}, code)
        if err or code /= 0 then
            putln("Error: ", fullpath, " ", err, " exit code: ", code)
            return
        else
            putln("Success: ", fullpath)
        end

        chdir("../../test-runner")
    end
    putln("Finished tests")
end