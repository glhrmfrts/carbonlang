import rt::x86_64

fun main := do
    let s := "Hello World asd qwewq e\n"
    write(1, s.ptr, s.len)
end