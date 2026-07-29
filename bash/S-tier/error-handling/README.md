# Error Handling

## Introduction

An important part of programming is how to handle errors and close resources even if errors occur.

Because error handling is rather programming-language (and, here, shell-specific), the concrete behavior expected of your program is defined by the exercise's own tests rather than by a generic language-agnostic description. In the Bash track, this exercise focuses on validating the arguments a script is invoked with and responding to bad input with the right exit status, rather than on `trap`/resource-cleanup mechanics.

## Instructions

Implement various kinds of error handling and resource management.

This exercise requires you to handle various errors. Because error handling is rather programming language specific, you'll have to refer to the tests for your track to see what's exactly required.

### Bash-specific instructions

The goal of this exercise is to consider the number of arguments passed to your program.

Note that you can pass empty strings as arguments:

```bash
./program ""
```

This is different from passing no arguments at all:

```bash
./program
```

- If your program is run with exactly one argument (even if it is an empty string), treat it as a person's name and print a greeting message.
- If it is run with zero arguments or more than one argument, print an error message and exit with a non-zero status.

## My Solution Idea

