typealias FileHandle := int

fun stdin() => FileHandle := do
    return 0
end

fun stdout() => FileHandle := do
    return 1
end

fun stderr() => FileHandle := do
    return 2
end