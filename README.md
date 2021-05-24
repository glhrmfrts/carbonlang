# Carbon

Carbon is a statically-strongly-typed programming language.

<p align="center">
<img src="https://github.com/glhrmfrts/carbon/blob/main/carbon.png">
</p>

## TODO

-X assignment
-X pointer deref / indexing
-X stack arguments / more than 4 args
- if statements
- for/while statements
- structs / tuples / user types
- global vars (?)
- more/better type checking and errors
- floating point types support
- investigate entry points for receiving command-line args
- integrate linking process

## Hello world

```go
import std;

func main(argc: int, argv: &[]string): int {
    std::println("Hello world!");
    return 0;
}
```

## Factorial

```go
import std;

func fac(x: <T: integral_type>) {
    return case x of {
        0    => 1;
        1    => 1;
        else => x * fac(x - 1);
    }
}

func main(): int {
    std::println(fac(7));
}
```

## String formatting + Error handling

```go
import std;

func get_greeting_or_throw_error(): ?[language_error] string {
    return ...;
}

func main(): int {
    std::readln("your name: ")
        then (let name: string) in
            get_greeting_or_throw_error(language="en")
        then (let gretting: string) in
            std::println("%s, %s!" % {greeting, name})
        else (catch error: language_error) in
            std::println(std::err, "Oops! something went wrong")
        else (catch error: std::io_error) in
            std::println(std::err, "Oops! something went wrong");
}
```

## Compile-time variadic arguments + function overloading

```go
import std;

func concat_stuff(value: <T>, values: <Ts...>): string {
    return value->to_string() .. concat_stuff(values...);
}

func concat_stuff(value: <T>): string {
    return value->to_string();
}
```

## Goals

- Better than C.
- Simpler than C++.
- Inspired by ML languages.
- Meta-programming ease of use.
- Pragmatic.
- Self-learning most of all.

## Non-goals.

- Purity.
- Performance.
- Hand-holding.

## Implementation

Currently the compiler is implemented in C++17 outputting MSVC-compatible x64 assembly code (my main development machine is Windows). In the future I want to add a ARMv7 or C backend.

Features implemented:

- Immutable local variables (`let` declarations).
- Function overloading.
- Function calls.
- Basic arithmetic operations.
- Declaration position independence.

## License

MIT
