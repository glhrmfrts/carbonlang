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

## Introduction

```go
#include <stdio.h>

func main(argv: []string) {
    printf("Hello, %s, welcome to Carbon!\n", argv[1].data);
    return 0;
}
```

Like C/C++, Carbon is a statically typed, compiled language with manual memory management.

## Variables and Assignments

### Declarations

All Carbon variables must be declared. Variables in Carbon are introduced with the `let` or `var` keywords:

```go
func myfunc() {
    let a: int = 3;
    var b: double;
}
```

### Initialization

Initializers are optional if the type has a valid [zero-value](#zero-value).
If an initializer is omitted, then the variable will receive it's type's zero-value.
If an initializer is specified, then Carbon can infer the variables type automatically:

```go
func myfunc() {
    let a: double; // a will have value '0.0'
    let b = 3.0; // b will have type 'double'
}
```

If you don't want the compiler to initialize the variable for you, you can use the `noinit` tag:

```go
func myfunc() {
    var a: int = noinit;
}
```

You can only use the `noinit` tag with `var` declarations, that is, mutable variables.

### Immutable vs mutable variables

The `let` form declares a immutable variable, similar to `const` in C/C++:

```go
func myfunc() {
    let a = 3.0;
    a = 6.0; // ERROR: cannot re-assign a 'let' value, use 'var' instead
}
```

To create a mutable variable and re-assign it, use the `var` declaration form:

```go
func myfunc() {
    var a = 3.0; // a will have type 'double'
    a = 6.0; // ok
}
```

## Control Flow

Carbon's control flow is similar to C in that includes `if`, `while`, `switch` statements, except the `for` statement which is different.

### If Statements

```go
if (a || b && !c) {
    printf("then\n");
}
else if (c) {
    printf("else if\n");
}
else {
    printf("else\n");
}
```

### Switch Statements

TODO.

### While Statements

```go
while (check_condition()) {
    printf("still running...\n");
}
```

### For Statements

For statements have several forms, a simple integer incrementing one:

```go
// 'i' increments from 0 to 10 exclusive.
for (i in 0,10) {
    printf("%d\n", i);
}
```

Similar to the above but with a custom step argument:

```go
// 'i' increments by 2 every iteration of the loop.
for (i in 0,10,2) {
    printf("%d\n", i);
}
```

It also works with from greater to smaller:

```go
// 'i' decrements by 1 every iteration of the loop, from 10 to -10 exclusive.
for (i in 10,-10) {
    printf("%d\n", i);
}
```

--- 

### For Statements With Iterators

TODO.

---

## Functions

We've already seen some simple function definitions. Functions in Carbon are defined using the `func` keyword:

```go
func min(a: int, b: int): int {
    if (a < b) {
        return a;
    }
    else {
        return b;
    }
}
```

### Type inference

The return type is optional, if you omit it, Carbon will infer the return type from the return statements.

```go
func max(a: int, b: int) { // the return type is 'int'
    if (a > b) {
        return a;
    }
    else {
        return b;
    }
}
```

All the return statements' types must be implicitly convertible to one another. If that fails, then the function is assumed to return a [variant type](#variant-types):

```go
func max(a: int, b: float) { // the return type is '(int | float)'
    if (a > cast[int](b)) {
        return a;
    }
    else {
        return b;
    }
}
```

The argument types are also optional, if you omit it, Carbon will infer them when the function is called.

```go
func max(a, b) {
    // compiles for any type that can compare with the '>' operator
    if (a > b) {
        return a;
    }
    else {
        return b;
    }
}

func main() {
    let a: int = 3;
    let b: int = 4;
    let result = max(a, b); // the call has type 'max(int, int): int'
    let result2 = max(5.0, 6.0); // the call has type 'max(double, double): double'
}
```

### Multiple Return Values

Functions can also return multiple values, which are packed into [tuples](#tuples):

```go
func sort2(a: int, b: int): {int, int} {
    if (a < b) {
        return a, b
    }
    else {
        return b, a
    }
}
```

### Independent Declaration Order

Functions (and any other form of declaration) can be declared anywhere in the source code. This is different from C/C++, where you need to forward declare everything you reference. In this example, `main`'s body uses `max` before it is declared, and it is perfectly valid:

```go
func main() {
    let a: int = 3;
    let b: int = 4;
    let result = max(a, b);
}

func max(a, b) {
    if (a > b) {
        return a;
    }
    else {
        return b;
    }
}
```

---

## Types and operators

### Primitive Types

Carbon has the standard set of primitive types a systems programming language is expected to have:

- Signed Integers: `int, int8, int16, int32, int64`
- Unsigned Integers: `uint, uint8, uint16, uint32, uint64`
- Floating point: `float, double`
- Boolean: `bool`

Integers are explicitly sized except for `int` and `uint` which should only be used when the particular size is not important. Most implicit conversions from C are also valid in Carbon. The one major exception is the bool type. Unlike C, all control-flow explicitly requires a bool and integers are not explicitly convertible to bool.

```go
if (10) { } // ERROR: if statement condition must have bool type or be convertible to bool
if (10 == 0) { }
```

You can force the conversion from `int` to `bool` using an explicit cast:

```go
let a: bool = cast[bool] 10;
```

### Primitive Operators

Primitive types have the standard operators defined:

- Arithmetic: `- + * / %`
- Comparison: `< <= > >= == !=`
- Logical: `&& || !`
- Bitwise: `& | ~ ^ << >>`

### Pointers And References

Carbon contains two ways of referring to memory, which together provide a functionality equivalent to pointers in C. The syntax is almost identical to pointers and references in C++, but the way you use them is different.

#### Pointers

Pointers have syntax `*T` (pointer to type `T`), they point to a memory address that contains the value of the type specified, but unlike C, they literally just *point* to something, and cannot change the contents of the value pointed-to, in other words, pointers in Carbon are read-only:

```go
func main() {
    let value: int = 1;
    let p_value: *int = &value;
    printf("address: %p, value: %d\n", p_value, *p_value);

    *p_value = 3; // ERROR: cannot modify value pointed by read-only pointer
}
```

#### References

References have syntax `&T` (reference to type `T`), they are like a mutable pointer and allows changing the value through dereferencing:

```go
func main() {
    let value: int = 1;
    let ref_value: &int = &value;
    printf("address: %p, value: %d\n", ref_value, *ref_value);

    *ref_value = 3; // ok to modify

    printf("address: %p, value: %d\n", ref_value, *ref_value);
}
```

As you can see, the syntax to create a pointer or reference is the same: `&value` (where value is a lvalue). In fact, when you do `&value` you always get a reference, and if needed, the reference is implicitly converted to a pointer. The inverse is not true however, you cannot convert a pointer to a reference because once something is immutable, it should stay that way. In other words, pointers and references are covariant to one another.

#### Nullability

Neither pointers or references have a "null" value, ideally, they should always point or refer to something that exists. You can use the [optional type](#optional-type) together with a pointer/reference to achieve that effect, but in a much safer and reasonable way.

#### Pointer Arithmetic

Carbon also doesn't have pointer arithmetic, you can do it through [unsafe cast](#unsafe-cast), but it is highly discouraged.


### Arrays

Arrays are similar to C's and they're always statically sized:

```go
let a: [4]int; // array of 4 ints
a[0] = 1;
a[1] = 2;
a[2] = 3;
a[3] = 4;
```

You can also use `...` to construct a variable sized (but still static) array:

```go
let a = [...]int{ 1, 2, 3, 4, 5, 6 }; // a has type '[6]int'
```

The array contents are always initialized to their type's zero-value. If you initialize an array with less elements than it's type's size, the rest of the elements will also be zero-initialized.

```go
let a = [6]int{ 1, 2, 3 }; // a[3] to a[5] are initialized to 0
```

If you don't want to initialize the array you can use the `noinit` tag:

(**NOTE: using the `noinit` tag with a `let` variable is valid when the variable is of an aggregate type.**)

```go
let a: [10]int = noinit;
```

You can initialize only part of the array as well:

```go
let a = [10]int{ 1, 2, 3, noinit... }; // only the first 3 elements are initialized
```

Or initialize part of the array to a specific value:

```go
let a = [10]int{ 1, 2, 3, 100... }; // every element but the first 3 are initialized to 100
```

### Slices

Slices are like "views" to arrays, which can refer to a part of the array's data, but doesn't own it. They also come in **mutable** and **immutable** forms, with the syntax being similar to [pointers and references](#pointers-and-references).

- The **immutable** slice has syntax `[*]T` (immutable slice to array of T).
- The **mutable** slice has syntax `[&]T` (mutable slice to array of T).

You can create slices by using the `array[A,B]` or `array&[A,B]` syntaxes, where **A** and **B** are of the same integral numeric type, **B** is exclusive:

```go
let a: [10]int;

let slice = a[0,3]; // 'slice' has type '[*]int', and contains 3 elements from index 0 to 2;

let mut_slice = a&[5,10]; // 'mut_slice' has type '[&]int', and contains 5 elements from index 5 to 9;
```

To access the slice data you can use the indexing operator, the same way you access an array's data:

```go
let a: [10]int;

let slice = a[0,3]; // 'slice' has type '[*]int';

printf("%d, %d, %d\n", slice[0], slice[1], slice[2]);
```

To modify the array referred by the slice you also use the indexing operator in a **mutable** slice:

```go
let a: [10]int;

let mut_slice = a&[5,10]; // 'mut_slice' has type '[&]int';

mut_slice[0], mut_slice[1] = 100, 200; // equivalent to a[5], a[6] = 100, 200
```

#### Length

To get the length of a slice, you use the `.len` property

```go
let a: [10]int;
let slice = a[0,3];
printf("length: %d\n", slice.len);
```

#### Slices And Arrays Lifetime

Like with pointers and references, it's important to ensure that the array referred to by a slice is "alive" throughout the whole lifetime of the slice. For example, this code is invalid, and since Carbon doesn't have any Lifetime checking/validation yet, it will produce undefined behavior:

```go
func get_data(): [*]int {
    let a: [10]int;
    return a[0,5]; // 'a' is only valid until this function ends, but we're returning a slice referring to it.
}

func main() {
    let elems = get_data();

    // dangerous! 'elems' possibly contains garbage data and acessing it produces undefined behavior.
    printf("%d \n", elems[0]);
}
```

#### Nullability

Also like pointers and references, slices don't have a "null" value, use the [optional type](#optional-type) for that.

## Implementation

Currently the compiler is implemented in C++17 outputting MSVC-compatible x64 assembly code (my main development machine is Windows). In the future I want to add a ARM64 or C backend.

## License

MIT
