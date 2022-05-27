import rt::syscall as syscall

const MAP_SHARED := 0x01
const MAP_PRIVATE := 0x02
const MAP_SHARED_VALIDATE := 0x03
const MAP_TYPE := 0x0f
const MAP_FIXED := 0x10
const MAP_ANON := 0x20

const MAP_ANONYMOUS := MAP_ANON

const PROT_NONE      := 0
const PROT_READ      := 1
const PROT_WRITE     := 2
const PROT_EXEC      := 4
const PROT_GROWSDOWN := 0x01000000
const PROT_GROWSUP   := 0x02000000

-- mmap with default parameters
fun mmap(size: int) => &opaque := do
    return syscall::mmap(nil, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0)
end

fun munmap(ptr: &opaque, size: int) := do
    syscall::munmap(ptr, size)
end