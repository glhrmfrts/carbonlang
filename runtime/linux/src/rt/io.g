import "rt/syscall" as syscall

typealias file_handle := int

fun stdin() => file_handle := do
    return 0
end

fun stdout() => file_handle := do
    return 1
end

fun stderr() => file_handle := do
    return 2
end

fun exit(code : int) := do
    syscall.exit(code)
end