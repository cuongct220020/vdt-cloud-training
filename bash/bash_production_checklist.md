# Bash Production Checklist

## 1. Structure and Hygiene

-   [ ] Script starts with `#!/usr/bin/env bash`
-   [ ] Uses `set -euo pipefail`
-   [ ] No undefined variables used
-   [ ] Logic organized inside functions
-   [ ] `main()` function exists
-   [ ] No large logic blocks in global scope

## 2. Input Handling

-   [ ] Argument count validated
-   [ ] Empty input handled
-   [ ] Invalid input rejected
-   [ ] All variables quoted `"${var}"`
-   [ ] Uses `"$@"` instead of `$*`


## 3. Stream and Pipeline Design

-   [ ] Script works with stdin
-   [ ] No hardcoded file paths
-   [ ] Output contains only result data
-   [ ] Debug logs go to stderr
-   [ ] Script can be chained in pipelines


## 4. Text Processing Discipline

-   [ ] Correct tool used for parsing task
-   [ ] Avoids unnecessary subshells
-   [ ] Avoids useless pipelines
-   [ ] Loop logic is explicit and readable


## 5. Logic Robustness

-   [ ] Handles edge cases
-   [ ] Handles long input
-   [ ] Handles special characters
-   [ ] Exit codes are meaningful
-   [ ] Success returns exit 0


## 6. Testability

-   [ ] Works with argument input
-   [ ] Works with pipe input
-   [ ] Works with file redirection
-   [ ] Can run with `set -x` debug mode


## 7. Portability

-   [ ] Avoids non‑portable shell features
-   [ ] Avoids unnecessary external dependencies
-   [ ] Runs in minimal container environment



## 8. Code Quality

-   [ ] Variable names are descriptive
-   [ ] Code prioritizes readability
-   [ ] No overly clever one‑liners
-   [ ] Comments explain why, not what



## 9. DevOps Mindset Validation

Before marking done, confirm:

-   [ ] Script can run in cron
-   [ ] Script can run in CI
-   [ ] Failure does not corrupt pipeline
-   [ ] Script can be reused


## 10. Completion Criteria

A script is considered complete only if:

-   [ ] Passes Exercism tests
-   [ ] Passes this checklist
-   [ ] Author understands every line
-   [ ] Author can explain logic clearly
