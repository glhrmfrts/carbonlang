-- A dumb linear allocator with blocks that never get re-used, only freed when they are not referenced anymore.

local type memory_block = struct of
    ptr         : opaque
    filled      : int
    capacity    : int
    allocations : int
    id          : int
    prev        : &memory_block
end

local let last_block : &memory_block
local let last_block_id : int

local fun alloc_in_block(block: in out memory_block, size: int) => opaque = do
    let ptr = cast(uintptr) block.ptr + cast(uintptr) block.filled
    block.filled = _ + size
    block.allocations = _ + 1
    --putln("---- Allocating memory: ", cast(int)cast(uintptr)ptr, " of: ", size, " allocations: ", block.allocations)
    return cast(opaque) ptr
end

fun align(size: int, alignment: int) => int = do
    return size + (-size & (alignment - 1))
end

fun alloc(usersize: int) => opaque = do
    const ALIGNMENT = 16
    const MIN_BLOCK_SIZE = 4096

    let asize = align(usersize, ALIGNMENT)

    let pblock = last_block
    for pblock /= nil do
        if pblock.filled + asize < pblock.capacity then
            return alloc_in_block(@pblock, asize)
        end
        pblock = pblock.prev
    end

    let block_size = align(asize + #sizeof(memory_block), MIN_BLOCK_SIZE)

    pblock = cast(&memory_block) mmap(block_size)
    if pblock /= nil then
        memset(pblock, 0, block_size)
        pblock.ptr = cast(opaque)(cast(uintptr)pblock + #sizeof(memory_block))
        pblock.capacity = block_size - #sizeof(memory_block)
        pblock.id = last_block_id + 1
        last_block_id = _ + 1

        pblock.prev = last_block
        last_block = pblock

        --putln("Allocating block: ", pblock.id," of: ", block_size)

        --putln("CALLER: ", pblock.allocations)

        let result = alloc_in_block(@pblock, asize)

        --putln("CALLER: ", pblock.allocations)

        return result
    end

    return nil
end

fun free(ptr: opaque) = do
    let pblock = last_block
    let prevblock : &memory_block

    for pblock /= nil do
        if ptr >= pblock.ptr and cast(uintptr)ptr < cast(uintptr)pblock.ptr + cast(uintptr)pblock.capacity then
            --putln("found block ", pblock.id)
            break
        end
        prevblock = pblock
        pblock = pblock.prev
    end

    --putln("Freeing memory: ", cast(int)cast(uintptr)ptr)

    if pblock /= nil then
        pblock.allocations = _ - 1

        if pblock.allocations == 0 then
            -- | --- last_block --- | --- pblock --- | ---prev --- |

            if last_block == pblock then
                last_block = pblock.prev
            else if prevblock /= nil then
                prevblock.prev = pblock.prev
            end

            --putln("Freeing block: ", pblock.id," of: ", pblock.capacity + #sizeof(memory_block))

            munmap(pblock, #sizeof(memory_block) + pblock.capacity)
        end
    end
end
