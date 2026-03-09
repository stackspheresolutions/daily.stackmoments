---
title: "Type System, Conversions & Boxing"
date: 2026-02-24T12:00:00+00:00
weight: 100
draft: false
toc: true
---


## Type System, Conversions & Boxing

* Implicit vs explicit conversions
* Numeric promotion rules
* Boxing & unboxing
* `var` vs `dynamic`
* `is` vs `as`
* Checked vs unchecked
* Nullable value types

---

# 1 Implicit vs Explicit Conversions

C# allows **implicit conversion** when no data loss can occur.

Example:

```csharp
int x = 10;
long y = x;   // implicit
```

Why allowed?

Because `long` can represent all `int` values safely.

Now reverse:

```csharp
long x = 10;
int y = x;    // compile error
```

Must cast explicitly:

```csharp
int y = (int)x;
```

Because data loss *might* occur.

---

## Numeric Promotion Trap

```csharp
byte a = 10;
byte b = 20;
byte c = a + b;   // compile error
```

Why?

Arithmetic operations promote operands to `int`.

So `a + b` becomes `int`.

Correct:

```csharp
byte c = (byte)(a + b);
```

---

# 2 Constant Expression Exception

This compiles:

```csharp
byte x = 10;
byte y = 20;
byte z = 30;  // literal fits range
```

But this:

```csharp
byte z = 10 + 20;  // works
```

Why?

Because it’s a constant expression evaluated at compile time.

But:

```csharp
byte z = x + y;  // fails
```

Because runtime arithmetic promotes to int.

The compiler is stricter with variables than constants.

---

# 3 Boxing and Unboxing

Boxing = wrapping a value type inside an object.

```csharp
int x = 10;
object o = x;   // boxing
```

Unboxing:

```csharp
int y = (int)o;
```

Important: Unboxing requires exact type.

```csharp
object o = 10;
long y = (long)o;   // runtime error
```

Even though int → long is valid normally.

Because unboxing must match original boxed type.

Correct:

```csharp
int temp = (int)o;
long y = temp;
```

---

## Boxing Creates Copy

```csharp
int x = 5;
object o = x;
x = 10;

Console.WriteLine(o);  // 5
```

Because boxing copies value.

---

# 4 is vs as

## is (type test)

```csharp
object o = "test";

if (o is string s)
{
    Console.WriteLine(s.Length);
}
```

Performs:

* Type check
* Safe cast

---

## as (safe cast)

```csharp
object o = "test";
string s = o as string;
```

If cast fails → returns null.

Cannot use with value types (unless nullable).

```csharp
object o = 10;
int? x = o as int?;   // valid
```

---

# 5 var vs dynamic

## var

Compile-time type inference.

```csharp
var x = 10;  // int
x = "test";  // compile error
```

Type is fixed at compile time.

---

## dynamic

Runtime binding.

```csharp
dynamic x = 10;
x = "test";  // allowed
```

Errors happen at runtime, not compile time.

---

# 6 Checked vs Unchecked

Default context is unchecked (unless configured).

```csharp
int x = int.MaxValue;
x++;  // wraps silently
```

Checked block:

```csharp
checked
{
    int x = int.MaxValue;
    x++;   // OverflowException
}
```

---

## Constant Overflow Is Always Checked

```csharp
int x = int.MaxValue + 1;  // compile-time error
```

Because constant expressions are always checked.

---

# 7 Nullable Value Types

```csharp
int? x = null;
```

Equivalent to:

```csharp
Nullable<int>
```

---

## Nullable Comparison

```csharp
int? x = null;
Console.WriteLine(x == null); // True
```

---

## Null-Coalescing Operator

```csharp
int? x = null;
int y = x ?? 5;  // 5
```

---

## Lifted Operators

```csharp
int? a = 5;
int? b = null;

Console.WriteLine(a + b); // null
```

Operators “lift” to nullable context.

---

# 8 Pattern Matching Conversions

```csharp
object o = 5;

if (o is int x)
{
    Console.WriteLine(x);
}
```

Combines:

* Type check
* Cast
* Variable assignment

---

# 9 Switch Expressions

```csharp
int x = 5;

var result = x switch
{
    1 => "One",
    5 => "Five",
    _ => "Other"
};
```

# 10 Core Mental Model

Conversions in C# are governed by:

* Safety (no implicit data loss)
* Static type at compile time
* Runtime type during casting
* Numeric promotion rules
* Nullable lifting
