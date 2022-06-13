import "rt/syscall" as syscall

const PATH_MAX = 4096

typealias file_handle = int

fun stdin() => file_handle = do
    return 0
end

fun stdout() => file_handle = do
    return 1
end

fun stderr() => file_handle = do
    return 2
end

fun exit(code: int) = do
    syscall.exit(code)
end

fun chdir(path: string) = do
    discard syscall.chdir(to_cstr(path, array[PATH_MAX] of byte{}))
end