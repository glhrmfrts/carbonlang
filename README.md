# Carbon

Carbon is a statically-strongly-typed programming language.

<p align="center">
<img src="https://github.com/glhrmfrts/carbon/blob/main/carbon.png">
</p>

## Design

Source code -> Tokens (Lexer) -> Untyped AST (Parser) -> Typed AST (Type System) -> Typed IR -> Codegen

## TODO

- [X] parser
- [X] type system
- [X] IR
- [X] codegen: windows x64
- [X] function declaration
- [X] function overload
- [X] local variables
- [X] basic math operations
- [X] declaration position independence
- [X] modules
- [X] assignment
- [X] type checking
- [X] pointer deref / indexing
- [X] stack arguments / more than 4 args
- [X] if statements
- [X] while statements
- [X] for statement (range-based)
- [X] blocks as scopes
- [X] aggregate type assignment/declaration from init lists
- [X] aggregate type assignment/declaration from lvalues
- [X] catch up on the codegen
- [X] cleanup pointers in node struct, transform to methods
- [X] aggregate type function arguments
- [X] aggregate type return value
- [X] struct / tuples
- [ ] arrays
- [ ] slices
- [ ] defer statements and expression
- [ ] user types
- [ ] for statement (array-based)
- [ ] function pointers
- [ ] global vars (?)
- [ ] catch up on the codegen
- [ ] more/better type checking and errors
- [ ] floating point types support
- [ ] investigate entry points for receiving command-line args
- [ ] catch up on the codegen
- [ ] integrate linking process
- [ ] user type constructors
- [ ] std library design
- [ ] codegen: linux x64
- [ ] codegen: linux ARM64
- [ ] vectorization/SIMD support
- [ ] raii stuff (?)
- [ ] closures
- [ ] rewrite compiler / self-hosting

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
- Meta-programming.
- Pragmatic.
- Self-learning.

## Non-goals.

- Purity.
- Performance.
- Hand-holding.

## Implementation

Currently the compiler is implemented in C++17 outputting MSVC-compatible x64 assembly code (my main development machine is Windows). In the future I want to add a ARM64 or C backend.

Features implemented:

- Immutable local variables (`let` declarations).
- Function overloading.
- Function calls.
- Basic arithmetic operations.
- Declaration position independence.

## License

MIT
