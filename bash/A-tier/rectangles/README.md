# Rectangles

## Introduction

ASCII diagrams are a simple, text-only way to sketch boxes and shapes using characters like `+`, `-`, and `|`.
Because a diagram is just a grid of characters, it's possible to scan it programmatically and pick out every rectangle that the corners and edges form, including small rectangles nested inside larger ones.

## Instructions

Count the rectangles in an ASCII diagram like the one below.

```text
   +--+
  ++  |
+-++--+
|  |  |
+--+--+
```

The above diagram contains these 6 rectangles:

```text


+-----+
|     |
+-----+
```

```text
   +--+
   |  |
   |  |
   |  |
   +--+
```

```text
   +--+
   |  |
   +--+


```

```text


   +--+
   |  |
   +--+
```

```text


+--+
|  |
+--+
```

```text

  ++
  ++


```

You may assume that the input is always a proper rectangle (i.e. the length of every line equals the length of the first line).

## My Solution Idea

