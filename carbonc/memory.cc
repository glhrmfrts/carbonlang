#include "memory.hh"

namespace carbon {

namespace {

std::size_t next_pow2(std::size_t n) {
    std::size_t p = 1;
    if (n && !(n & (n - 1)))
        return n;

    while (p < n)
        p <<= 1;

    return p;
}

std::size_t alignment_offset(const memory_arena::bucket& b) {
    const std::uintptr_t resultPtr = reinterpret_cast<std::uintptr_t>(b.data) + b.size;
    const std::size_t mask = b.alignment - 1;
    if (resultPtr & mask) {
        return b.alignment - (resultPtr & mask);
    }
    return 0;
}

memory_arena::bucket create_bucket(std::size_t cap, std::size_t alignment) {
    auto b = memory_arena::bucket{};
    b.data = new unsigned char[cap];
    b.end = b.data + cap;
    b.capacity = cap;
    b.size = 0;
    b.alignment = alignment;
    return b;
}

bool fits_in_bucket(const memory_arena::bucket& b, std::size_t size) {
    const std::size_t offset = alignment_offset(b);
    return (b.size + size + offset) <= b.capacity;
}

void* bucket_alloc(memory_arena::bucket& b, std::size_t size) {
    const std::size_t offset = alignment_offset(b);
    void* addr = static_cast<void*>(b.data + b.size + offset);
    b.size += size + offset;
    return addr;
}

}

memory_arena::memory_arena(std::size_t bucketSize, std::size_t alignment) {
    _bucket_size = next_pow2(bucketSize);
    _alignment = alignment;
}

memory_arena::~memory_arena() {
    for (auto& bucket : _buckets) {
        delete[] bucket.data;
    }
}

void* memory_arena::alloc(std::size_t size) {
    for (auto& bucket : _buckets) {
        if (fits_in_bucket(bucket, size)) {
            return bucket_alloc(bucket, size);
        }
    }

    // all buckets are full, create a new one
    _buckets.push_back(create_bucket(_bucket_size, _alignment));
    return bucket_alloc(_buckets.back(), size);
}

void memory_arena::clear() {
    for (auto& bucket : _buckets) {
        bucket.size = 0;
    }
}

}