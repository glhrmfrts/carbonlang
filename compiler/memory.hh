#pragma once

#include <list>
#include <memory>

namespace carbon {

struct memory_arena {
    struct bucket {
        unsigned char* data;
        unsigned char* end;
        std::size_t size;
        std::size_t capacity;
        std::size_t alignment;
    };

    std::list<bucket> _buckets;
    std::size_t _bucket_size;
    std::size_t _alignment;

    explicit memory_arena(std::size_t bucket_size, std::size_t alignment = sizeof(std::size_t));

    ~memory_arena();

    void* alloc(std::size_t);

    void clear();
};

template <typename T> void arena_ptr_deleter(T* ptr) { ptr->~T(); }

template <typename T> using arena_ptr = std::unique_ptr<T, decltype(&arena_ptr_deleter<T>)>;

template <typename T, typename... Args> auto make_in_arena(memory_arena& arena, Args&&... args) -> arena_ptr<T> {
    auto ptr = reinterpret_cast<T*>(arena.alloc(sizeof(T)));
    new (ptr) T{std::forward<Args>(args)...};
    return arena_ptr<T>{ptr, &arena_ptr_deleter<T>};
}

template <typename T> auto alloc_many(memory_arena& arena, size_t count) {
    return reinterpret_cast<T*>(arena.alloc(sizeof(T) * count));
}

}