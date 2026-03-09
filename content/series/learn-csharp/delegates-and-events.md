---
title: "Type System, Conversions & Boxing"
date: 2026-02-25T12:00:00+00:00
weight: 100
draft: false
toc: true
---


# 🔥 Delegates & Events (Deep Dive)


# 1 What Is a Delegate Really?

A delegate is:

> A type-safe function pointer object.

It is a reference type that holds:

* Method pointer
* Target object (for instance methods)

Example:

```csharp
delegate int Add(int a, int b);

Add add = (x, y) => x + y;

Console.WriteLine(add(2, 3)); // 5
```

Internally, `add` is an object containing:

* Method metadata
* Possibly a reference to a target instance

---

# 2 Delegates Are Objects

```csharp
Add a = (x, y) => x + y;

Console.WriteLine(a.GetType());
```

Delegates inherit from `System.MulticastDelegate`.

They are reference types.

---

# 3 Multicast Delegates

Delegates can hold multiple methods.

```csharp
void A() => Console.WriteLine("A");
void B() => Console.WriteLine("B");

Action act = A;
act += B;

act();
```

Output:

```
A
B
```

Invocation order is the order of subscription.

---

## Important Rule

Delegates are immutable.

When you do:

```csharp
act += B;
```

A new delegate instance is created.

Original delegate remains unchanged.

---

# 4 Multicast + Return Values (Danger Area)

What happens here?

```csharp
int M1() { return 1; }
int M2() { return 2; }

Func<int> f = M1;
f += M2;

Console.WriteLine(f());
```

Output?

2

Why?

Because for multicast delegates with return values:

* All methods execute
* Only the last return value is returned

---

# 5 Exception Behavior

If one method throws:

```csharp
void A() { Console.WriteLine("A"); }
void B() { throw new Exception(); }
void C() { Console.WriteLine("C"); }

Action act = A;
act += B;
act += C;

act();
```

Execution stops at B.

C is never executed.

Delegates do not automatically continue after exception.

---

# 6 Removing Methods (-=)

```csharp
act -= B;
```

Removes last matching occurrence from invocation list.

If multiple identical methods exist, only the last one is removed.

---

# 7 Delegates and Equality

Two delegates are equal if:

* Same method
* Same target
* Same invocation list order

Example:

```csharp
Action a1 = A;
Action a2 = A;

Console.WriteLine(a1 == a2); // True
```

But:

```csharp
Action a1 = A;
Action a2 = B;

Console.WriteLine(a1 == a2); // False
```

Multicast order matters:

A + B ≠ B + A

---

# 8 Instance Method Delegates

```csharp
class Test
{
    public void Show() => Console.WriteLine("Hi");
}

var t1 = new Test();
var t2 = new Test();

Action a1 = t1.Show;
Action a2 = t2.Show;

Console.WriteLine(a1 == a2); // False
```

Why?

Same method, different target instance.

Delegate equality checks both method and target.

---

# 9 Anonymous Methods & Lambdas

Each lambda creates a new delegate instance.

```csharp
Action a1 = () => Console.WriteLine("Hi");
Action a2 = () => Console.WriteLine("Hi");

Console.WriteLine(a1 == a2); // False
```

Even though body is identical.

Because compiler generates separate method instances.

---

# 10 Closures

```csharp
int x = 10;

Action act = () => Console.WriteLine(x);

x = 20;

act();
```

Output?

20

Why?

Lambdas capture variables, not values.

Compiler creates a hidden closure class.

All lambdas referencing same variable share that instance.

---

# 11 Classic Closure Trap

```csharp
var actions = new List<Action>();

for (int i = 0; i < 3; i++)
{
    actions.Add(() => Console.WriteLine(i));
}

foreach (var a in actions)
{
    a();
}
```

Output?

3
3
3

Why?

All lambdas capture the same `i`.

Fix:

```csharp
for (int i = 0; i < 3; i++)
{
    int temp = i;
    actions.Add(() => Console.WriteLine(temp));
}
```

Now output:
0
1
2

---

# 12 Events

An event is a delegate with restricted access.

```csharp
public event Action OnSomething;
```

Outside the class:

* You can only use += or -=
* You cannot invoke it

Inside the class:

* You can invoke it

---

## Why Events Exist

To prevent external code from doing:

```csharp
obj.OnSomething = null;  // illegal
```

Events protect invocation list.

---

# 13 Safe Event Invocation Pattern

```csharp
OnSomething?.Invoke();
```

Prevents NullReferenceException.

---

# 14 Event Backing Field

Compiler generates a private delegate field behind the event.

Events are syntactic sugar over delegates.

---

# 15 Variance with Delegates

Covariant return:

```csharp
Func<string> f1 = () => "Hello";
Func<object> f2 = f1;  // Allowed
```

Contravariant parameter:

```csharp
Action<object> a1 = x => {};
Action<string> a2 = a1; // Allowed
```

Delegates support variance automatically.

---

# 16 Invocation List

You can inspect:

```csharp
Delegate[] list = act.GetInvocationList();
```

Returns array of delegates.

Used internally in multicast behavior.

---

# 17 Delegates vs Func / Action

Built-in generic delegates:

* Action → void return
* Func<T> → returns T
* Predicate<T> → returns bool

Prefer these over custom delegates in modern code.

---

# Final Mental Model

Delegates are:

* Objects
* Immutable
* Multicast-capable
* Equality-sensitive
* Closure-enabled
* Variance-aware

Events are:

* Delegate wrappers
* Invocation-protected

