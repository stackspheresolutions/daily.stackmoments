---
title: "Lesson 01 — C# Basics"
date: 2026-02-24T12:00:00+00:00
weight: 100
draft: false
toc: true
---

## Introduction

This lesson covers the basics of C#: syntax, variables, and a simple program.

### Hello World

```csharp
using System;

class Program {
    static void Main() {
        Console.WriteLine("Hello, Stack Moments!");
    }
}
```

### Variables

C# is statically typed. Example:

```csharp
int count = 5;
string name = "Alice";
bool isActive = true;
```

### Next steps

- Try compiling with `dotnet` or an online C# REPL.
- In the next lesson we'll cover control flow and methods.
