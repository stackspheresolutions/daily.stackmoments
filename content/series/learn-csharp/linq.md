---
title: "LINQ — Deferred Execution, Immediate Execution, and Hidden Traps"
date: 2026-02-25T12:00:00+00:00
weight: 100
draft: false
toc: true
---

# 1 What LINQ Really Is

LINQ queries are usually just chains of extension methods on `IEnumerable<T>`.

Example:

```csharp
var result = numbers.Where(x => x > 5);
```

That line does **NOT** execute the query.

It builds a pipeline.

Execution happens only when you enumerate.

---

# 2 Deferred Execution (Critical Concept)

Deferred execution means:

> Query is evaluated only when iterated.

Example:

```csharp
var numbers = new List<int> {1, 2, 3};

var query = numbers.Where(x => x > 1);

numbers.Add(4);

foreach (var n in query)
{
    Console.WriteLine(n);
}
```

Output:
2
3
4

Why?

Because evaluation happens at enumeration time, not declaration time.

This is the #1 LINQ MCQ trap.

---

# 3 Immediate Execution

Some LINQ methods force immediate execution.

Examples:

* ToList()
* ToArray()
* Count()
* First()
* Sum()
* Max()

Example:

```csharp
var result = numbers.Where(x => x > 1).ToList();
numbers.Add(4);

foreach (var n in result)
{
    Console.WriteLine(n);
}
```

Output:
2
3

Because ToList() materialized the result immediately.

---

# 4 Side Effects Trap

```csharp
var numbers = new List<int> {1, 2, 3};

var query = numbers.Where(x =>
{
    Console.WriteLine("Filtering " + x);
    return x > 1;
});

foreach (var n in query)
{
    Console.WriteLine(n);
}
```

Output:

Filtering 1
Filtering 2
2
Filtering 3
3

Filtering happens during enumeration.

Not during query definition.

---

# 5 Multiple Enumeration Trap

```csharp
var query = numbers.Where(x =>
{
    Console.WriteLine("Running");
    return x > 1;
});

query.Count();
query.Count();
```

Output:

Running
Running
Running
Running
Running
Running

The filter runs twice.

Because each Count() enumerates again.

LINQ queries are not cached unless materialized.

---

# 6 Order of Execution in Chain

```csharp
var result = numbers
    .Where(x => x > 1)
    .Select(x => x * 2);
```

Execution order during enumeration:

1. Take element
2. Apply Where
3. If true → apply Select
4. Yield result

LINQ is streaming (for most operators).

---

# 7 Deferred vs Immediate Operators

### Deferred (lazy)

* Where
* Select
* Take
* Skip
* OrderBy (deferred but buffers internally)

### Immediate

* ToList
* ToArray
* Count
* First
* Any
* Sum

Important: OrderBy is deferred but sorts when enumerated.

---

# 8 First vs FirstOrDefault

```csharp
var x = numbers.First();
```

Throws if empty.

```csharp
var x = numbers.FirstOrDefault();
```

Returns default value.

MCQ favorite.

---

# 9 Any vs Count

```csharp
if (numbers.Any())
```

Stops at first match.

```csharp
if (numbers.Count() > 0)
```

Enumerates entire collection (if not optimized).

Prefer Any() for performance.

---

# 10 LINQ with Mutable Source

```csharp
var list = new List<int> {1,2,3};
var query = list.Where(x => x > 1);

list.Clear();

foreach(var x in query)
{
    Console.WriteLine(x);
}
```

Output: nothing.

Because query sees current state at enumeration time.

---

# 11 Captured Variables in LINQ

```csharp
int threshold = 2;

var query = numbers.Where(x => x > threshold);

threshold = 0;

foreach (var n in query)
{
    Console.WriteLine(n);
}
```

Output: 1 2 3

Why?

Lambda captures variable, not value.

Same closure rule as delegates.

---

# 12 OrderBy Trap

```csharp
var result = numbers.OrderBy(x => x);

numbers.Add(0);

foreach(var n in result)
{
    Console.WriteLine(n);
}
```

0 appears in sorted result.

Because sorting happens at enumeration time.

---

# 13 LINQ Execution Summary

| Concept              | Behavior             |
| -------------------- | -------------------- |
| Where                | Deferred             |
| Select               | Deferred             |
| ToList               | Immediate            |
| Count                | Immediate            |
| Multiple enumeration | Re-executes          |
| Lambda capture       | Captures variable    |
| OrderBy              | Deferred but buffers |

---

# 14 LINQ Rapid Fire

1

```csharp
var list = new List<int> {1,2,3};
var query = list.Where(x => x > 1);
list.Add(4);
Console.WriteLine(query.Count());
```

Answer: 3

---

2

```csharp
var list = new List<int> {1,2,3};
var query = list.Where(x => x > 1).ToList();
list.Add(4);
Console.WriteLine(query.Count);
```

Answer: 2

---

3

```csharp
var list = new List<int> {1,2,3};
var query = list.Select(x => x * 2);
Console.WriteLine(query.First());
```

Output: 2

Select runs only as needed.

---

# 15 IQueryable vs IEnumerable

IEnumerable:

* Executes in memory
* Uses delegates

IQueryable:

* Builds expression trees
* Executes remotely (e.g., database)
