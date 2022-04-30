# Carbon programming language

Carbon is a statically-typed, compiled programming language with manual memory management.

It's syntax is a mix of Go, C, Swift and maybe Kotlin.

Carbon doesn't have a hello world yet because it's so early that we still don't have the init/entrypoint setup yet. But look at this piece of code that parses an integer to get an idea:

```go
func parseIntRem(s : []pure uint8, radix : int) : {int, []pure uint8, bool} {
    let value : int
    let count : usize

    for (i in 0,s.len) {
        if (isNumeric(s[i])) {
            value = value * radix + (s[i] - '0')
            count += 1
        } else {
            break
        }
    }

    return value, []pure uint8{ s.ptr + count, s.len - count }, count > 0
}
```

Carbon is still under construction, take a look at the messy repository to look at more realistic examples.

## Why?

Because.

Just kidding. Well, I'm not going to pretend that there's a valid reason to write a compiler from scratch these days. It's mostly for fun and learning, if you like fun and learning then come along.

Now, for more sane reasons: I've noticed a lot of imperative languages don't fully explore the power of tuples like some functional languages do (e.g. Erlang, Elixir). I also really like Lua and it's flexibility with tables. I want to achieve something at least close to that but in a static, compiled language that is close to C in terms of low-level programming.

## Current Features

Implemented features from solid to very experimental.

- Struct, tuple, slice, pointer and array types.
- Namespaces based on file paths.
- Declaration position independence.
- Built-in error type.
- Crude parsing of C #define and structs.
- Inline Assembly.
- Type inference (e.g. functions without types).
- Compile-time expression evaluation (const).
- Generic functions (Very WIP).
- Type constructors (Very WIP).

## Back-end

Currently, Linux x64 System V ABI is supported, Windows is not very solid but is also supported through NASM and GoLink. In the future I want to implement **armv6** back-end. Of course, for realistic use cases this probably needs a C or LLVM back-end.

## Currently TODO

- Implement rest of the arithmetic instructions.
- Floating-point arithmetic.
- Flat unions (C-like).
- Conditional compilation.
- Support linking libc.
- Basic stdlib and build system.

## Ideas for the future

- Very slim error handling mechanism.
- Built-in vector math / linear algebra.
- Closures.

## Some art

<p align="center">
<img src="https://github.com/glhrmfrts/carbon/blob/main/carbon.png">
</p>

## License

MIT

