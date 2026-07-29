# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal learning repo for Bash shell scripting, following two external references:

- **[roadmap.sh/shell-bash](https://roadmap.sh/shell-bash)** — the skill roadmap/curriculum this repo is structured around.
- **[exercism.org/tracks/bash](https://exercism.org/tracks/bash/exercises)** — the source of the practice exercises themselves (problem statements in each exercise's `README.md` are adapted from Exercism).

Exercises are organized into difficulty/purpose tiers rather than following Exercism's own track order. `README.md` at the repo root is the single learning doc for this directory, in three parts: Part 1 is the tier list below, Part 2 is a concept notebook following roadmap.sh/shell-bash, and Part 3 is the S-tier production checklist (see below). Part 1's tiers:

- **S-tier** — "Production Grade Skill": exercises meant to be solved to a production-quality bar (see checklist below).
- **A-tier** — "Automation Skill Builder": general scripting fluency exercises.
- **B-tier** — "Luyện tư duy logic (không sát production)": logic-building exercises, not held to production standards.

Each exercise lives in `<Tier>/<exercise-name>/` and contains:
- `README.md` — the Exercism problem statement, ending in a `## My Solution Idea` section for notes before implementing.
- `<exercise_name>.sh` — the solution script. Most of these are currently **empty stubs** waiting to be implemented; do not assume a script has content just because the file exists.

There is no test runner, build step, or linter configured in this repo (no `.bats` files, no CI config, no Makefile). Verify scripts by running them directly, e.g.:

```bash
bash A-tier/reverse-string/reverse_string.sh "somestring"
```

If asked to add automated tests, ask whether they should follow Exercism's own test suites (not present here) or a lightweight `bats`/manual-assertion setup, rather than assuming.

## Script conventions

`A-tier/reverse-string/reverse_string.sh` is the one fleshed-out example in the repo and shows the expected shape for a solution:

```bash
#!/usr/bin/env bash

set -euo pipefail

main () {
    local input_string=$1
    # ...
}

main "$@"
```

Follow this shape for new solutions: shebang, `set -euo pipefail`, all logic inside a `main()` (or other named functions) rather than top-level script body, `local` for function-scoped variables, and invoke with `main "$@"` at the bottom.

Script filenames are not perfectly consistent with their directory name (kebab-case dirs, mixed snake_case/kebab-case filenames, e.g. `robot_simulator.sh` vs `phone-number.sh`) — always check the exercise directory for the exact existing filename rather than assuming a naming pattern.

## S-tier production bar

Part 3 of `README.md` ("Production Checklist") is the review checklist that S-tier scripts must pass before being considered done. When writing or reviewing an S-tier exercise, hold it to this bar specifically:

- Structure: `#!/usr/bin/env bash`, `set -euo pipefail`, logic organized in functions with a `main()`, nothing significant at global scope.
- Input handling: validate argument count and reject invalid/empty input; quote all variable expansions (`"${var}"`); use `"$@"` not `$*`; provide `-h`/`--help` usage text.
- Pipelines: script should work with stdin, avoid hardcoded paths, keep stdout to result data only (debug/log output goes to stderr), and be chainable in a pipeline.
- Robustness: handle edge cases, long input, and special characters; use meaningful, documented, stable exit codes (0 on success).
- Testability: works via argument, pipe, and file-redirection input; runnable under `set -x`.
- Portability: avoid non-portable/bashism-heavy features and unnecessary external dependencies; must run in a minimal container; passes `shellcheck` cleanly.
- Code quality: descriptive variable names, no overly clever one-liners, comments explain *why* not *what*.
- Security: no hardcoded secrets, no `eval`/dynamic commands from untrusted input, `mktemp` for temp files, no unnecessary root/sudo.
- Idempotency & resilience: safe to re-run, timeouts on external calls, retry/backoff for transient failures, `flock` against concurrent cron/CI runs, traps `INT`/`TERM` as well as `EXIT`.
- Done means: passes the relevant Exercism tests, passes this checklist, and the author can explain every line.

A/B-tier exercises are not held to this full bar (per `README.md`, B-tier is explicitly "không sát production" — logic practice, not production style), but the structural basics (shebang, `set -euo pipefail`, functions, quoting) are still good defaults.
