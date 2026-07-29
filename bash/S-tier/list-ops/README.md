# List Ops

## Introduction

In functional languages, list operations like `length`, `map`, and `reduce` are very common building blocks, used instead of explicit loops to work through a collection of values.

This exercise asks you to build those building blocks yourself, from scratch, so that you understand what's actually happening underneath the convenient library functions you'd normally reach for.

## Instructions

Implement basic list operations, without using existing functions.

The precise number and names of the operations to be implemented will be track dependent, to avoid conflicts with existing names, but the general operations you will implement include:

- `append` (given two lists, add all items in the second list to the end of the first list);
- `concatenate` (given a series of lists, combine all items in all lists into one flattened list);
- `filter` (given a predicate and a list, return the list of all items for which `predicate(item)` is true);
- `length` (given a list, return the total number of items within it);
- `map` (given a function and a list, return the list of the results of applying `function(item)` on all items);
- `foldl` (given a function, a list, and an initial accumulator, fold (reduce) each item into the accumulator from the left);
- `foldr` (given a function, a list, and an initial accumulator, fold (reduce) each item into the accumulator from the right);
- `reverse` (given a list, return a list with all the original items, but in reversed order).

Note that the ordering in which arguments are passed to the fold functions (`foldl`, `foldr`) is significant.

## My Solution Idea

