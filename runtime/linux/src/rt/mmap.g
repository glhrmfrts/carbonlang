import "rt/syscall" as syscall

local const MAP_SHARED = 0x01
local const MAP_PRIVATE = 0x02
local const MAP_SHARED_VALIDATE = 0x03
local const MAP_TYPE = 0x0f
local const MAP_FIXED = 0x10
local const MAP_ANON = 0x20

local const MAP_ANONYMOUS = MAP_ANON

local const PROT_NONE      = 0
local const PROT_READ      = 1
local const PROT_WRITE     = 2
local const PROT_EXEC      = 4
local const PROT_GROWSDOWN = 0x01000000
local const PROT_GROWSUP   = 0x02000000

-- mmap with default parameters
fun mmap(size: int) => rawptr = do
    return syscall.mmap(nil, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0)
end

fun munmap(ptr: rawptr, size: int) = do
    discard syscall.munmap(ptr, size)
end