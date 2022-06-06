import "nested/types" as types

-- TODO(bug): cannot refer to enum component outside of declared module

fun to_kernel_flags(flags: types.open_flags) => int := do
    let lflags := types.open_flags.append
    return cast(int) lflags
end

fun main := do
end