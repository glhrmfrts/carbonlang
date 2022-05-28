import rt

fun do_something := do end

fun main := do
    if something() then |err|
        do_something()
    end
end

error (
    SOME_ERROR
)

fun something => error := do
    return SOME_ERROR
end