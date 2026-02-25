---
title: "The Complete Guide to Equality in C#"
date: 2026-02-24T12:00:00+00:00
weight: 100
draft: false
toc: true
---

# The Complete Guide to Equality in C#

Equality in C# is not a single feature. It is a layered system involving:

* Operator overloading
* Virtual methods
* Static type binding
* Runtime type dispatch
* Structural comparison
* Hash code contracts
* Generic equality mechanisms
* Pattern matching behavior

To truly understand equality, you must separate compile-time behavior from runtime behavior.

This guide documents equality behavior across:

* Primitive types
* string
* class
* record
* Tuple
* ValueTuple
* Arrays
* List<T>
* Dictionary<TKey, TValue>
* IEquatable<T>
* IEqualityComparer<T>
* IStructuralEquatable
* HashSet and Dictionary internals
* Pattern matching and null checks

---

# 1. The Three Equality Mechanisms

C# provides three core equality mechanisms:

1. `==` operator
2. `.Equals()` method
3. `ReferenceEquals()` method

Each behaves differently.

---

# 2. ReferenceEquals — Pure Identity

Always checks whether two references point to the same object in memory.

```csharp
var a = new object();
var b = new object();

Console.WriteLine(object.ReferenceEquals(a, b)); // False
```

Cannot be overridden. Always reference-based.

---

# 3. Equals() — Virtual Equality

`Equals()` is virtual and can be overridden.

```csharp
var a = "test";
var b = new string("test".ToCharArray());

Console.WriteLine(a.Equals(b)); // True
```

Uses string’s overridden equality logic.

---

# 4. == Operator — Static Binding

The `==` operator is resolved at compile time.

Operator overload selection depends entirely on **static types**.

This is the single most important rule.

---

# 5. Primitive Types

```csharp
int a = 5;
int b = 5;

Console.WriteLine(a == b); // True
```

Primitive types use value equality.

---

# 6. String Equality

`string` is a reference type with value-based equality.

```csharp
string a = "test";
string b = new string("test".ToCharArray());

Console.WriteLine(a == b);               // True
Console.WriteLine(ReferenceEquals(a,b)); // False
```

Why?

* `string` overloads `==`
* Compares characters
* Ignores reference identity

---

## String Interning

String literals are interned.

```csharp
string x = "test";
string y = "test";

Console.WriteLine(ReferenceEquals(x,y)); // True
```

But:

```csharp
string x = new string("test".ToCharArray());
string y = "test";

Console.WriteLine(ReferenceEquals(x,y)); // False
```

`new string()` bypasses the intern pool.

Interning affects reference identity — not value equality.

---

## Static Type Controls Operator Selection

```csharp
object a = new string("test".ToCharArray());
string b = "test";

Console.WriteLine(a == b); // False
```

Because:

* Static types: object and string
* Compiler binds to `object.operator ==`
* Reference comparison is performed

Force string equality:

```csharp
Console.WriteLine((string)a == b); // True
```

---

# 7. Class Equality (Default Behavior)

Classes use reference equality unless overridden.

```csharp
class Person
{
    public string Name { get; set; }
}

var p1 = new Person { Name = "A" };
var p2 = new Person { Name = "A" };

Console.WriteLine(p1 == p2);       // False
Console.WriteLine(p1.Equals(p2));  // False
```

---

## Implementing Value Equality in Classes

```csharp
class Person : IEquatable<Person>
{
    public string Name { get; set; }

    public bool Equals(Person other)
        => other is not null && Name == other.Name;

    public override bool Equals(object obj)
        => Equals(obj as Person);

    public override int GetHashCode()
        => Name?.GetHashCode() ?? 0;
}
```

If you override `Equals`, you must override `GetHashCode`.

---

# 8. Record Equality

Records provide value-based equality automatically.

```csharp
record Person(string Name, int Age);

var p1 = new Person("A", 30);
var p2 = new Person("A", 30);

Console.WriteLine(p1 == p2); // True
```

Compiler generates:

* `Equals`
* `GetHashCode`
* `==`
* `!=`
* `Deconstruct`

---

## Record Equality Is Type-Sensitive

```csharp
record Person(string Name);
record Employee(string Name) : Person(Name);

Person p = new Person("A");
Person e = new Employee("A");

Console.WriteLine(p == e); // False
```

Runtime type must match.

---

## Overriding Record Equality

```csharp
record Person(string Name, int Age)
{
    public virtual bool Equals(Person other)
        => other is not null && Name == other.Name;

    public override int GetHashCode()
        => Name.GetHashCode();
}
```

You can customize equality, but must keep hash codes consistent.

---

# 9. Tuple vs ValueTuple

## Tuple (Reference Type)

```csharp
var t1 = Tuple.Create(1,2);
var t2 = Tuple.Create(1,2);

Console.WriteLine(t1 == t2); // False
```

Reference comparison.

---

## ValueTuple (Struct)

```csharp
var t1 = (1,2);
var t2 = (1,2);

Console.WriteLine(t1 == t2); // True
```

Structural comparison — field-by-field.

---

## Boxing Changes Behavior

```csharp
object o1 = (1,2);
object o2 = (1,2);

Console.WriteLine(o1 == o2);      // False
Console.WriteLine(o1.Equals(o2)); // True
```

`==` uses reference equality after boxing.

---

# 10. Arrays and IStructuralEquatable

Arrays use reference equality by default.

```csharp
int[] a1 = {1,2,3};
int[] a2 = {1,2,3};

Console.WriteLine(a1 == a2); // False
```

---

## Structural Comparison

```csharp
using System.Collections;

var comparer = StructuralComparisons.StructuralEqualityComparer;

Console.WriteLine(comparer.Equals(a1, a2)); // True
```

Arrays implement `IStructuralEquatable`.

---

# 11. List<T> Equality

```csharp
var l1 = new List<int>{1,2};
var l2 = new List<int>{1,2};

Console.WriteLine(l1 == l2);      // False
Console.WriteLine(l1.Equals(l2)); // False
```

Structural comparison:

```csharp
l1.SequenceEqual(l2); // True
```

---

# 12. Dictionary Equality

```csharp
var d1 = new Dictionary<int,string>
{
    {1,"A"},
    {2,"B"}
};

var d2 = new Dictionary<int,string>
{
    {1,"A"},
    {2,"B"}
};

Console.WriteLine(d1 == d2); // False
```

Dictionaries compare keys using `EqualityComparer<TKey>.Default`.

Two dictionaries with same contents are not equal unless explicitly compared.

---

# 13. IEquatable<T>

Provides strongly typed equality.

Used by:

* EqualityComparer<T>.Default
* HashSet
* Dictionary

Example:

```csharp
struct Point : IEquatable<Point>
{
    public int X, Y;

    public bool Equals(Point other)
        => X == other.X && Y == other.Y;
}
```

Avoids boxing and improves performance.

---

# 14. IEqualityComparer<T>

Used to define external equality logic.

Example:

```csharp
class PersonComparer : IEqualityComparer<Person>
{
    public bool Equals(Person x, Person y)
        => x.Name == y.Name;

    public int GetHashCode(Person obj)
        => obj.Name.GetHashCode();
}
```

Used in:

```csharp
var set = new HashSet<Person>(new PersonComparer());
```

---

# 15. EqualityComparer<T>.Default

Used internally by generic collections.

It:

1. Uses IEquatable<T> if implemented
2. Falls back to overridden Equals
3. Otherwise uses reference equality

---

# 16. HashSet / Dictionary Internals

Process:

1. Compute hash code → choose bucket
2. Compare using Equals within bucket

Rule:

If `Equals` returns true → `GetHashCode` must return same value.

Violation causes corrupted collections.

---

# 17. Pattern Matching and Equality

Pattern matching is not the same as `==`.

```csharp
object o = 5;

Console.WriteLine(o is 5); // True
Console.WriteLine(o == 5); // False
```

Pattern matching performs:

* Runtime type check
* Value comparison

---

## Null Pattern

```csharp
if (obj is null)
```

Safer than:

```csharp
if (obj == null)
```

Because `==` can be overloaded.

---

# 18. Nullable Reference Types

Nullable annotations affect compile-time warnings only.

Runtime equality behavior does not change.

```csharp
string? a = null;
string? b = null;

Console.WriteLine(a == b); // True
```

---

# 19. Performance Considerations

Reference equality → O(1)
Structural equality → O(n)

Deep comparisons can be expensive.

Equality design impacts performance in large systems.

---

# 20. Complete Equality Summary

| Type       | == Behavior | Equals    | Default Nature |
| ---------- | ----------- | --------- | -------------- |
| Primitive  | Value       | Value     | Built-in       |
| string     | Value       | Value     | Overridden     |
| class      | Reference   | Reference | Default        |
| record     | Value       | Value     | Generated      |
| Tuple      | Reference   | Reference | Default        |
| ValueTuple | Value       | Value     | Structural     |
| Array      | Reference   | Reference | Default        |
| List       | Reference   | Reference | Default        |
| Dictionary | Reference   | Reference | Default        |

---

# Final Mental Model

When evaluating equality in C#, always ask:

1. What is the static type?
2. Which operator is chosen?
3. Is this reference or value comparison?
4. Is hashing involved?
5. Is boxing happening?
6. Is structural comparison being used?

Once you separate:

* Compile-time binding
* Runtime dispatch
* Structural comparison
* Hashing contract

Equality becomes predictable.
