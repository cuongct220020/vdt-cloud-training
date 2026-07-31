# Bash Learning Guide

The single learning documentation for this directory — following [roadmap.sh/shell-bash](https://roadmap.sh/shell-bash) and [Exercism's bash track](https://exercism.org/tracks/bash/exercises). Three parts: which exercise to solve next, what to study before/while solving it, and the quality bar S-tier solutions are held to.

## Contents

- [Part 1 — Exercise Tiers](#part-1--exercise-tiers)
- [Part 2 — Concept Notebook](#part-2--concept-notebook)
- [Part 3 — Production Checklist](#part-3--production-checklist)

---

## Part 1 — Exercise Tiers


### Các bài ở tier S - Production Grade Skill

- [grep](S-tier/grep/) — reimplement a subset of grep's pattern-matching and flag behavior in bash
- [word-count](S-tier/word-count/) — count occurrences of each word in text, handling punctuation, case, and contractions
- [transpose](S-tier/transpose/) — transpose rows and columns of text, padding uneven line lengths correctly
- [phone-number](S-tier/phone-number/) — clean and validate differently formatted NANP phone numbers into a standard format
- [markdown](S-tier/markdown/) — refactor a working but messy markdown-to-html parser for readability
- [error-handling](S-tier/error-handling/) — validate script argument count and exit with correct status codes
- [list-ops](S-tier/list-ops/) — implement basic list operations (map, filter, reduce, reverse, etc.) from scratch
- [matching-brackets](S-tier/matching-brackets/) — verify brackets, braces, and parentheses are balanced and nested correctly
- [luhn](S-tier/luhn/) — validate identifier strings using the Luhn checksum algorithm
- [nucleotide-count](S-tier/nucleotide-count/) — count occurrences of each DNA nucleotide in a sequence, erroring on invalid input
- [tournament](S-tier/tournament/) — tally football match results into a ranked standings table
- [sublist](S-tier/sublist/) — classify whether one list equals, contains, is contained by, or is unrelated to another
- [variable-length-quantity](S-tier/variable-length-quantity/) — implement variable length quantity integer encoding and decoding


### Các bài ở tier A - Automation Skill Builder

- [reverse-string](A-tier/reverse-string/) — reverse the characters of a given string
- [two-fer](A-tier/two-fer/) — generate a "one for X, one for me" phrase given an optional name
- [anagram](A-tier/anagram/) — find candidate words that are anagrams of a given target word
- [pangram](A-tier/pangram/) — determine whether a sentence contains every letter of the alphabet
- [protein-translation](A-tier/protein-translation/) — translate an RNA codon sequence into a sequence of amino acids
- [run-length-encoding](A-tier/run-length-encoding/) — implement run-length encoding and decoding of repeated characters
- [resistor-color](A-tier/resistor-color/) — look up numeric values encoded by resistor color bands
- [isbn-verifier](A-tier/isbn-verifier/) — validate whether a string is a correctly formatted ISBN-10 number
- [prime-factors](A-tier/prime-factors/) — compute the prime factors of a given natural number
- [binary-search](A-tier/binary-search/) — implement binary search to find an item's position in a sorted list
- [gigasecond](A-tier/gigasecond/) — calculate the date and time one gigasecond after a given date
- [rectangles](A-tier/rectangles/) — count the rectangles formed by characters in an ASCII diagram
- [robot-simulator](A-tier/robot-simulator/) — simulate a robot's position and facing direction from movement instructions
- [wordy](A-tier/wordy/) — parse and evaluate simple arithmetic word problems into an integer answer
- [rotational-cipher](A-tier/rotational-cipher/) — implement a Caesar/rot-n rotational cipher for encoding text
- [rail-fence-cipher](A-tier/rail-fence-cipher/) — implement encoding and decoding for the zig-zag rail fence cipher

### Các bài ở tier B - Luyện tư duy logic (không sát production)

- [difference-of-squares](B-tier/difference-of-squares/) — compute the difference between the square of the sum and sum of squares
- [allergies](B-tier/allergies/) — determine a person's allergies from a bitmask-style allergy test score
- [armstrong-numbers](B-tier/armstrong-numbers/) — determine whether a number is an Armstrong (narcissistic) number
- [darts](B-tier/darts/) — calculate the score earned by a dart landing at given Cartesian coordinates
- [knapsack](B-tier/knapsack/) — choose items maximizing value without exceeding a knapsack's weight capacity
- [poker](B-tier/poker/) — pick the best poker hand(s) from a list of hands
- [change](B-tier/change/) — compute the fewest coins needed to make a given amount of change
- [two-bucket](B-tier/two-bucket/) — determine actions needed to measure an exact amount using two buckets

## Part 2 — Concept Notebook

Following the curriculum at [roadmap.sh/shell-bash](https://roadmap.sh/shell-bash), reorganized into a learnable order instead of the roadmap's flat alphabetical topic graph.

### How to use this notebook

- **Deep-dive sections** (marked `[deep]` in the table of contents) cover the concepts you'll actually write in scripts every day: variables, control flow, functions, expansion, redirection, error handling, text processing. Each gets an explanation, syntax, 2-3 runnable examples, and a **Gotchas** callout for the non-obvious behavior that trips people up.
- **Reference tables** cover the long tail of individual CLI tools (compression, networking, package managers, editors, system services). You don't need prose to learn what `unzip` does — just the purpose, common flags, and one example.
- **Practice:** lines point at exercises already in this repo (`A-tier/`, `B-tier/`, `S-tier/` — see `bash/CLAUDE.md`) that let you immediately apply the concept instead of just reading about it.

### Table of Contents

1. [Orientation](#1-orientation)
2. [Bash Fundamentals](#2-bash-fundamentals-deep) `[deep]`
3. [Navigating the Filesystem & File Basics](#3-navigating-the-filesystem--file-basics)
4. [Viewing & Slicing Text](#4-viewing--slicing-text)
5. [Text Processing Power Tools](#5-text-processing-power-tools-deep) `[deep]`
6. [Redirection & Pipes](#6-redirection--pipes-deep) `[deep]`
7. [Variables, Expansion & Data](#7-variables-expansion--data-deep) `[deep]`
8. [Operators & Comparisons](#8-operators--comparisons-deep) `[deep]`
9. [Control Flow](#9-control-flow-deep) `[deep]`
10. [Functions & Scope](#10-functions--scope-deep) `[deep]`
11. [Reading Input](#11-reading-input)
12. [Error Handling & Debugging](#12-error-handling--debugging-deep) `[deep]`
13. [Processes & Job Control](#13-processes--job-control)
14. [Scheduling & System Services](#14-scheduling--system-services)
15. [Users, Permissions & Security](#15-users-permissions--security)
16. [Compression & Archiving](#16-compression--archiving)
17. [Networking](#17-networking)
18. [Package Managers](#18-package-managers)
19. [Editors](#19-editors)
20. [Terminal Multiplexing & Sessions](#20-terminal-multiplexing--sessions)
21. [Finding Things](#21-finding-things)
22. [Aliases, Customization & Wrap-up](#22-aliases-customization--wrap-up)


### 1. Orientation

**Shell vs. terminal**: the *terminal* (or terminal emulator) is the window/program that displays text and captures keystrokes. The *shell* is the program running inside it that reads your commands and executes them (bash, zsh, fish, sh, dash...). You're always talking to the shell; the terminal is just the glass between you and it.

**CLI vs. GUI**: a CLI (command-line interface) is text-in, text-out — scriptable, composable, remotely operable over SSH with almost no bandwidth. A GUI is discoverable and visual but hard to automate or repeat exactly. Production/ops work leans CLI because it's the only interface you can put in a script, cron job, or CI pipeline.

**The shell landscape:**

| Shell | Notes |
|---|---|
| `bash` (Bourne Again Shell) | The default on most Linux distros and what this notebook targets. Superset of POSIX `sh`. |
| `sh` | The POSIX standard shell interface — on Linux, `/bin/sh` is usually a symlink to `dash` or `bash` in POSIX mode. Write `#!/bin/sh` only if you mean strict POSIX, not bash extensions (arrays, `[[`, etc. aren't POSIX). |
| `dash` | Minimal, fast, POSIX-only — Debian/Ubuntu's `/bin/sh`. Scripts that work in `bash` can silently break under `dash` if they use bashisms. |
| `zsh` | macOS's default login shell since Catalina. Mostly bash-compatible for scripting, differs in interactive features (globbing, prompt). |
| `fish` | Friendly interactive shell, deliberately *not* POSIX-compatible — great to use, don't write portable scripts in it. |

**Getting help without leaving the terminal:**

| Command | Purpose | Example |
|---|---|---|
| `man <cmd>` | Full manual page for a command | `man grep` |
| `man -k <keyword>` / `apropos` | Search man page summaries | `man -k copy` |
| `<cmd> --help` | Quick usage summary most CLI tools support | `tar --help` |
| `help <builtin>` | Docs for bash *builtins* (`man` won't cover these) | `help read` |
| `type <cmd>` | Is this a builtin, alias, function, or a file on `$PATH`? | `type cd` |

---

### 2. Bash Fundamentals `[deep]`

#### The shebang and script anatomy

Every script starts with a shebang line telling the OS which interpreter to run it with:

```bash
#!/usr/bin/env bash
```

`env bash` (rather than hardcoding `/bin/bash`) finds bash on `$PATH`, which matters across machines where bash lives in different places (notably macOS, where the system `/bin/bash` is ancient and Homebrew's is elsewhere).

A well-formed script, matching the convention already used in this repo's `A-tier/reverse-string/reverse_string.sh`:

```bash
#!/usr/bin/env bash

set -euo pipefail   # fail fast — see chapter 12

main () {
    local input=$1
    echo "$input"
}

main "$@"
```

Putting all logic inside `main()` and calling it with `"$@"` at the bottom (rather than letting top-level statements run loose) keeps variables out of global scope by default and makes the script's entry point obvious.

**Direct execution**: to run a script as `./script.sh` instead of `bash script.sh`, it needs the shebang line *and* the executable bit: `chmod +x script.sh`.

#### Comments

```bash
# A comment runs to the end of the line. There is no block-comment syntax in bash.
echo "hi" # inline comments work too
```

#### Output: `echo` vs `printf`

```bash
echo "Hello, $USER"          # simplest case — adds a trailing newline
echo -n "no newline"         # suppress the newline
printf "%s is %d\n" "age" 30 # printf gives you real format control — prefer it when
                              # the string itself might contain a literal "-n" or backslashes,
                              # since echo's flag handling differs across shells
```

#### Variables and bash data types

Bash is **untyped at the shell level** — everything is stored as a string, including things that look like numbers. Arithmetic contexts (`(( ))`, `$(( ))`, `let`) reinterpret that string as a number; everywhere else it's text. The practical "data types" are: scalar strings, indexed arrays, associative arrays (bash 4+), and integers only in the sense that `declare -i` makes a variable auto-evaluate arithmetic on assignment.

```bash
name="Cuong"       # NO spaces around = — `name = "Cuong"` is parsed as a command called "name"
readonly PI=3.14   # can't be reassigned after this
declare -i count=0 # integer attribute: `count="abc"` becomes 0, `count+=1` does arithmetic, not concat
```

#### Environment variables vs. shell variables

A **shell variable** exists only in the current shell. An **environment variable** is exported and inherited by every child process that shell spawns (other programs, scripts you run from it).

```bash
LOCAL_VAR="only visible here"
export SHARED_VAR="visible to child processes too"

# setting for a single command's environment without polluting the shell:
SOME_VAR=value some_program
```

`env` (no args) or `printenv` lists exported variables; `set` (no args) lists *all* shell variables including non-exported ones.

#### Exit codes and `exit`

Every command returns an exit status: `0` means success, any nonzero value (1-255) means failure, and the specific nonzero value is meaningful by convention (e.g. `grep` returns `1` for "no match found", `2` for "an actual error"). `$?` holds the most recent exit status.

```bash
grep "pattern" file.txt
echo "$?"        # 0 if found, 1 if not found, 2 if file.txt doesn't exist

exit 0            # success
exit 1            # generic failure — use for "something went wrong"
```

**Gotchas**
- `$?` is overwritten by *every* command, including `echo` itself — capture it into a variable immediately if you need it later: `status=$?`.
- A script's own exit code is the exit code of the last command it ran, unless you call `exit <n>` explicitly.

**Practice:** `S-tier/error-handling` is built entirely around correct exit-code behavior; every S-tier script in this repo follows `set -euo pipefail` per [Part 3 — Production Checklist](#part-3--production-checklist).

---

### 3. Navigating the Filesystem & File Basics

| Command | Purpose | Common flags | Example |
|---|---|---|---|
| `pwd` | Print working directory | | `pwd` |
| `cd` | Change directory | `cd -` (previous dir), `cd ~` (home) | `cd /var/log` |
| `ls` | List directory contents | `-l` (long), `-a` (all incl. hidden), `-h` (human sizes) | `ls -lah` |
| `files/directories` (concept) | Everything in Unix is a file, including directories and devices | | |
| `file-permissions` (concept) | `rwx` for user/group/other — see `chmod` below | | `ls -l` shows `-rwxr-xr-x` |
| `file-test` (`[ -f ]`, `[ -d ]`, ...) | Test file properties in conditionals — see chapter 8 | `-f` (regular file), `-d` (dir), `-e` (exists), `-x` (executable) | `[ -f "$file" ] && echo exists` |
| `chmod` | Change permissions | `chmod +x`, `chmod 755`, `chmod -R` | `chmod +x script.sh` |
| `chown` | Change owner | `chown user:group` | `sudo chown cuong:staff file` |
| `chgrp` | Change group only | | `chgrp staff file` |
| `umask` | Default permission mask for newly created files | | `umask 022` |
| `stat` | Detailed file metadata (size, timestamps, inode) | | `stat file.txt` |
| `ln` | Create links | `-s` (symbolic link) | `ln -s target linkname` |
| `cp` | Copy files | `-r` (recursive) | `cp -r src/ dst/` |
| `mv` | Move/rename | | `mv old.txt new.txt` |
| `rm` | Remove files | `-r` (recursive), `-f` (force, no prompt) — **destructive, no undo** | `rm -rf build/` |
| `mkdir` | Make directory | `-p` (create parents, no error if exists) | `mkdir -p a/b/c` |
| `touch` | Create empty file / update timestamp | | `touch newfile.txt` |
| `mktemp` | Create a uniquely-named temp file/dir safely | `-d` (directory) | `tmpfile=$(mktemp)` |
| `mkfifo` | Create a named pipe (FIFO) for IPC between processes | | `mkfifo mypipe` |
| `mknod` | Create special files (devices, FIFOs) — rarely needed directly | | |
| `readlink` | Resolve a symlink to its target | `-f` (canonicalize full path) | `readlink -f script.sh` |
| `truncate` | Shrink/extend a file to an exact size | `-s` | `truncate -s 0 log.txt` (empty a file in place) |

**Gotcha**: always prefer `mktemp` over hand-rolling a temp filename (e.g. `/tmp/myfile$$`) — a predictable temp path is a symlink-attack / race-condition risk, and `mktemp` guarantees a unique, just-created file.

---

### 4. Viewing & Slicing Text

| Command | Purpose | Common flags | Example |
|---|---|---|---|
| `cat` | Print whole file(s) to stdout / concatenate files | `-n` (number lines) | `cat file1 file2 > combined` |
| `head` / `tail` | First / last N lines | `-n 20`, `tail -f` (follow, live updates) | `tail -f /var/log/syslog` |
| `less` / `more` | Paginated viewing of large files | `/pattern` to search inside `less` | `less bigfile.log` |
| `wc` | Count lines/words/bytes | `-l` (lines), `-w` (words), `-c` (bytes) | `wc -l file.txt` |
| `nl` | Number lines (like `cat -n` with more formatting control) | | `nl file.txt` |
| `od` | Octal/hex dump — inspect raw bytes, non-printable chars | `-c` (show chars) | `od -c file.bin` |
| `cut` | Extract columns/fields by delimiter or byte position | `-d','`, `-f2` (field 2), `-c1-5` | `cut -d',' -f2 data.csv` |
| `paste` | Merge lines from multiple files side-by-side | `-d` (delimiter) | `paste -d',' a.txt b.txt` |
| `sort` | Sort lines | `-n` (numeric), `-r` (reverse), `-k2` (sort by 2nd field), `-u` (unique) | `sort -n numbers.txt` |
| `uniq` | Collapse adjacent duplicate lines (usually piped after `sort`) | `-c` (count occurrences) | `sort file.txt \| uniq -c` |
| `tr` | Translate or delete characters | `tr 'a-z' 'A-Z'`, `tr -d '\n'` | `echo "hi" \| tr 'a-z' 'A-Z'` |
| `rev` | Reverse each line's characters | | `echo "abc" \| rev` → `cba` |
| `tee` | Write stdout to a file *and* pass it through — see chapter 6 | `-a` (append) | `cmd \| tee output.log` |
| `split` | Split a file into smaller pieces | `-l 1000` (lines per file), `-b 10M` (size) | `split -l 1000 big.csv part_` |
| `join` | Relational join of two sorted files on a common field | `-1`, `-2` (field in file 1 / file 2) | `join file1.txt file2.txt` |

**Practice:** `S-tier/word-count` combines several of these ideas (tokenizing, counting, sorting) even though it's implemented in pure bash rather than by shelling out to `sort`/`uniq`/`wc`.

---

### 5. Text Processing Power Tools `[deep]`

This is the chapter that matters most day-to-day — these three tools (plus regex) are how real shell scripts process data, and they map directly onto several exercises already in this repo.

#### `grep` — find lines matching a pattern

```bash
grep "error" app.log              # lines containing "error"
grep -i "error" app.log           # case-insensitive
grep -v "debug" app.log           # invert match — lines NOT containing "debug"
grep -c "error" app.log           # count matching lines instead of printing them
grep -E "err(or|s)" app.log       # extended regex (see below)
grep -rn "TODO" src/              # recursive, with line numbers
```

Exit status is the real signal for scripting: `0` = found at least one match, `1` = no match, `2` = error (e.g. file not found) — this is exactly the exit-code convention from chapter 2.

**Practice:** `S-tier/grep` has you reimplement a subset of `grep`'s own flag behavior in bash.

#### `sed` — stream editor (find/replace, line-based transforms)

```bash
sed 's/foo/bar/' file.txt         # replace FIRST match per line
sed 's/foo/bar/g' file.txt        # replace ALL matches per line (g = global)
sed -n '2,4p' file.txt            # print only lines 2-4 (-n suppresses default print)
sed -i.bak 's/foo/bar/g' file.txt # edit in place, keeping a .bak backup
sed '/^#/d' file.txt              # delete lines starting with #
```

**Gotcha**: `sed -i` behaves differently on macOS/BSD (`sed -i '' 's/.../.../'`) vs. GNU/Linux (`sed -i 's/.../.../'`) — the BSD version requires an explicit backup-suffix argument (even if empty). This is one of the most common "works on my machine" bash bugs.

#### `awk` — field-based text processing

`awk` treats each line as a record automatically split into fields (`$1`, `$2`, ... `$0` = whole line):

```bash
awk '{print $1}' file.txt                 # print first column (whitespace-delimited by default)
awk -F',' '{print $2}' data.csv           # custom delimiter
awk '{sum += $3} END {print sum}' data    # accumulate a total across all lines
awk '$2 > 100 {print $1}' data.txt        # conditional — print col 1 where col 2 > 100
```

Reach for `awk` over `cut`/`grep` combos once you need arithmetic or conditionals across columns — it's a small programming language, not just a filter.

#### Regular expressions

```bash
grep -E "^[0-9]+$" file.txt        # extended regex (ERE): + ? | ( ) work unescaped
grep "^[0-9]\+$" file.txt          # basic regex (BRE, grep's default): same thing needs \+ escaping
[[ "$str" =~ ^[a-z]+$ ]]           # bash's own regex match operator, always ERE-flavored
```

| Anchor/class | Meaning |
|---|---|
| `^` / `$` | start / end of line |
| `.` | any single character |
| `*` | zero or more of the previous atom |
| `+` (ERE only) | one or more |
| `[abc]` / `[^abc]` | one of / none of these chars |
| `\|` (ERE only) | alternation (or) |

**Gotcha**: `grep` defaults to BRE (basic regex), where `+`, `?`, `|`, `(`, `)` are literal characters unless escaped with `\`. Use `grep -E` (or `egrep`) to get ERE, where they're operators. This trips up almost everyone once.

**Practice:** `S-tier/phone-number` and `S-tier/markdown` are both regex/pattern-matching heavy; `S-tier/matching-brackets` is a good regex-adjacent parsing exercise.

#### Other text-processing utilities (reference)

| Command | Purpose | Example |
|---|---|---|
| `strings` | Extract printable text from a binary file | `strings /bin/ls \| grep usage` |
| `md5sum` / `sum` | Checksum a file (integrity check, not security) | `md5sum file.txt` |
| `patch` | Apply a diff to a file | `patch < changes.diff` |
| `strip` | Remove debug symbols from a binary | `strip mybinary` |
| `shred` | Overwrite a file's contents before deletion (best-effort secure delete) | `shred -u secret.txt` |
| `parse-yaml` (concept) | Reading structured config in bash usually means a helper function or shelling out to `yq`/`python` — bash has no native YAML/JSON support | |

---

### 6. Redirection & Pipes `[deep]`

Every process starts with three open file descriptors: `0` (stdin), `1` (stdout), `2` (stderr). Redirection just points these somewhere other than the terminal.

```bash
command > file.txt        # stdout → file (overwrite)
command >> file.txt        # stdout → file (append)
command 2> errors.txt      # stderr → file
command > out.txt 2>&1     # BOTH stdout and stderr → out.txt (order matters — see gotcha)
command < input.txt        # stdin ← file
command &> both.txt        # bash shortcut for "both stdout and stderr → file"
```

**Gotcha — redirection order**: `2>&1 > out.txt` and `> out.txt 2>&1` are NOT the same. Redirections are processed left to right, each pointing a descriptor at whatever the target *currently* points to:
- `> out.txt 2>&1` — stdout now points to `out.txt`; then stderr is pointed at "wherever stdout currently points" (`out.txt`). Both end up in the file. ✅
- `2>&1 > out.txt` — stderr is pointed at "wherever stdout currently points" (the terminal); then stdout is redirected to `out.txt`. stderr stays on the terminal. ❌ (usually a bug)

#### Pipes

```bash
cmd1 | cmd2      # cmd1's stdout becomes cmd2's stdin
ps aux | grep nginx | awk '{print $2}'    # chain several tools together — the Unix philosophy
```

**Gotcha**: each side of a pipe runs in its own **subshell** — variables set inside a piped command don't survive past the pipe:

```bash
count=0
echo "a b c" | tr ' ' '\n' | while read -r word; do count=$((count+1)); done
echo "$count"   # prints 0, not 3! The while loop ran in a subshell.
# fix: use process substitution instead of a pipe
count=0
while read -r word; do count=$((count+1)); done < <(echo "a b c" | tr ' ' '\n')
echo "$count"   # prints 3
```

#### `tee` — split a stream to a file and stdout at once

```bash
build.sh | tee build.log          # see output live AND save it
build.sh | tee -a build.log       # append instead of overwrite
```

#### Here-documents and here-strings

```bash
cat <<EOF
Multi-line text with $variable expansion.
Ends when EOF appears alone on a line.
EOF

cat <<'EOF'
No expansion here — quoting the delimiter disables $variable substitution.
EOF

grep "pattern" <<< "$single_string"   # here-string — feed one string as stdin, no here-doc needed
```

#### Command substitution

```bash
current_dir=$(pwd)              # preferred modern syntax
current_dir=`pwd`               # legacy backtick syntax — avoid, doesn't nest cleanly
files=$(ls *.txt | wc -l)
```

**Gotcha**: command substitution strips trailing newlines. Always quote the result when using it (`"$(cmd)"`) or word-splitting will silently mangle multi-word/multi-line output.

---

### 7. Variables, Expansion & Data `[deep]`

#### Parameter expansion — defaults, lengths, substrings

```bash
name="Cuong"
echo "${name}"              # basic expansion — braces disambiguate from surrounding text
echo "${#name}"              # length → 5
echo "${name:0:2}"           # substring, offset:length → "Cu"
echo "${name,,}"              # lowercase entire string (bash 4+)
echo "${name^^}"              # uppercase entire string

echo "${missing:-default}"    # use "default" if missing is unset OR empty (doesn't set it)
echo "${missing:=default}"    # same, but ALSO assigns missing=default
echo "${required:?must be set}"  # print error and exit if unset/empty
echo "${var:+alt}"             # use "alt" only if var IS set (inverse of :-)
```

#### Substring manipulation & case conversion (recap table)

| Expansion | Meaning |
|---|---|
| `${var#prefix}` | remove shortest matching prefix |
| `${var##prefix}` | remove longest matching prefix |
| `${var%suffix}` | remove shortest matching suffix |
| `${var%%suffix}` | remove longest matching suffix |
| `${var/old/new}` | replace first occurrence |
| `${var//old/new}` | replace all occurrences |

```bash
file="archive.tar.gz"
echo "${file%.*}"     # archive.tar   (strip shortest suffix after last .)
echo "${file%%.*}"    # archive       (strip longest suffix after first .)
```

#### Arithmetic

```bash
result=$((3 + 4 * 2))          # arithmetic expansion — standard, use this
(( count++ ))                  # arithmetic command — for side effects, no $ needed
if (( count > 10 )); then ... fi   # arithmetic context inside conditionals — no need for [ ]

expr 3 + 4                     # old external-command way — avoid in new code, slow & clunky
let "count = count + 1"        # another older form — (( )) is clearer
echo "scale=2; 10/3" | bc      # bc for FLOATING POINT — bash arithmetic is integer-only
```

**Gotcha**: `$((...))` is integer-only. `$(( 10 / 3 ))` is `3`, not `3.333`. Reach for `bc` or `awk` when you need decimals.

#### Declaring variables with attributes

```bash
declare -i num=5        # integer attribute — arithmetic on assignment automatically
declare -r CONST=1      # same as readonly — cannot be reassigned
declare -a arr          # explicitly declare as indexed array (usually not needed, arr=() is enough)
declare -A map          # REQUIRED for associative arrays — see below
typeset -i num=5        # ksh-era synonym for `declare`, still works in bash
```

#### Arrays (indexed)

```bash
fruits=("apple" "banana" "cherry")
echo "${fruits[0]}"          # apple
echo "${fruits[@]}"          # all elements
echo "${#fruits[@]}"          # length → 3
fruits+=("date")              # append
for f in "${fruits[@]}"; do echo "$f"; done   # always quote "${arr[@]}" when iterating
```

**Gotcha**: `${fruits[@]}` (quoted) expands to each element as a separate word, preserving elements with spaces. `${fruits[*]}` joins everything into one string with `$IFS` between them. Almost always want `[@]`, quoted.

**Practice:** `A-tier/reverse-string` builds a character array as a stack; `A-tier/rectangles` and `S-tier/transpose` process 2D grids as arrays of strings; `S-tier/matching-brackets` uses an array as a stack for bracket matching.

#### Associative arrays (bash 4+, key → value)

```bash
declare -A colors
colors["red"]="#FF0000"
colors["green"]="#00FF00"
echo "${colors["red"]}"
for key in "${!colors[@]}"; do echo "$key = ${colors[$key]}"; done   # ! gives you the KEYS
```

**Practice:** `S-tier/tournament` and `S-tier/word-count` both need a key→count/key→record lookup — the natural fit is an associative array. `A-tier/resistor-color` maps color names to numeric values, another associative-array-shaped problem.

#### `mapfile` / `readarray` — read lines straight into an array

```bash
mapfile -t lines < file.txt     # -t strips trailing newlines from each element
readarray -t lines < <(grep "error" app.log)
```

---

### 8. Operators & Comparisons `[deep]`

#### `[ ]` vs `[[ ]]` vs `(( ))`

| Construct | Use for | Notes |
|---|---|---|
| `[ ... ]` (= `test`) | POSIX-portable string/file tests | Needs careful quoting; word-splitting applies |
| `[[ ... ]]` | Bash-only string/file tests + pattern matching + `&&`/`\|\|` inside | Safer — no word-splitting on unquoted vars, supports `=~` regex |
| `(( ... ))` | Arithmetic comparisons | `(( a > b ))`, no `$` needed on variable names inside |

```bash
[ "$a" = "$b" ]        # POSIX string equality — note single =
[[ "$a" == "$b" ]]     # bash string equality — == also works, plus glob pattern matching:
[[ "$file" == *.txt ]] # true if $file ends in .txt (no quotes needed around the pattern)

(( a > b ))            # numeric comparison
[ "$a" -gt "$b" ]      # POSIX numeric comparison — -gt/-lt/-ge/-le/-eq/-ne, NOT >/</==
```

**Gotcha**: inside `[ ]`, `>` and `<` do *string* (lexicographic) comparison and additionally need escaping (`\>`) or they're parsed as redirection. Use `-gt`/`-lt` for numbers in `[ ]`, or switch to `(( ))`.

#### Logical operators

```bash
[[ -f "$file" && -r "$file" ]] && echo "readable"     # AND
[[ -z "$var" || "$var" == "default" ]] && echo "unset or default"  # OR
cmd1 && cmd2       # run cmd2 only if cmd1 succeeded (exit 0)
cmd1 || cmd2       # run cmd2 only if cmd1 FAILED
! [[ -f "$file" ]] && echo "missing"    # negation
```

#### `test` / `true` / `false`

`test` is the command form of `[ ]` (`[ "$a" = "$b" ]` and `test "$a" = "$b"` are identical — `[` is literally a command that requires a matching `]` as its last argument). `true` and `false` are commands that do nothing but return exit code 0 and 1 respectively — useful as placeholders or in `while true; do ... done` infinite loops.

**Practice:** `S-tier/sublist` and `B-tier/two-bucket` are comparison/state-logic heavy; `A-tier/isbn-verifier` and `S-tier/luhn` combine arithmetic comparisons with validation logic.

---

### 9. Control Flow `[deep]`

#### Conditionals

```bash
if [[ "$status" == "active" ]]; then
    echo "running"
elif [[ "$status" == "paused" ]]; then
    echo "paused"
else
    echo "unknown"
fi

case "$status" in
    active)  echo "running" ;;
    paused)  echo "paused" ;;
    *)       echo "unknown" ;;      # default case
esac
```

`case` shines over a long `if/elif` chain once you have several discrete string values to branch on — it also supports glob patterns per branch (`*.txt) ...;;`).

#### Loops

```bash
for i in 1 2 3; do echo "$i"; done
for i in {1..10}; do echo "$i"; done            # brace range
for i in $(seq 1 2 10); do echo "$i"; done        # step of 2, via seq
for file in *.txt; do echo "$file"; done          # glob expansion

count=0
while [[ $count -lt 5 ]]; do
    echo "$count"
    count=$((count + 1))
done

until [[ $count -ge 10 ]]; do    # inverse of while — loop UNTIL condition is true
    count=$((count + 1))
done
```

#### Loop control

```bash
for i in {1..10}; do
    [[ $i -eq 5 ]] && break       # exit the loop entirely
    [[ $((i % 2)) -eq 0 ]] && continue  # skip to next iteration
    echo "$i"
done
```

#### `select` — quick interactive menus

```bash
select option in "Start" "Stop" "Quit"; do
    case "$option" in
        Start) echo "starting" ;;
        Stop)  echo "stopping" ;;
        Quit)  break ;;
    esac
done
```

**Practice:** `A-tier/robot-simulator` is a state machine built on `case`; `A-tier/wordy` parses and dispatches on tokens with conditionals/case; `A-tier/rotational-cipher` and `A-tier/protein-translation` both loop over characters/codons with conditionals inside.

---

### 10. Functions & Scope `[deep]`

```bash
greet () {
    local name=$1              # ALWAYS `local` inside functions — see gotcha below
    echo "Hello, $name"
}
greet "Cuong"

add () {
    local sum=$(( $1 + $2 ))
    echo "$sum"                # "return" a value by printing it; capture with $(add 2 3)
}
result=$(add 2 3)

has_error () {
    [[ -n "$1" ]] && return 1   # return only sets the FUNCTION's exit code (0-255), not a value
    return 0
}
```

**Gotcha — scope**: variables in bash are **global by default**, even inside functions, unless declared `local`. Forgetting `local` is one of the most common bash bugs — a variable named the same as one in the caller gets silently clobbered.

```bash
x=10
overwrite () { x=20; }     # no `local` — this mutates the CALLER's x
overwrite
echo "$x"   # 20, not 10 — surprising if you expected function-local scope like most languages
```

**`return` vs. echo**: `return` (and a function's implicit exit status) can only be a number 0-255 — it's for signaling success/failure, not data. To "return" a string or number, `echo` it and capture with command substitution, as in `add` above.

**Positional parameters & `shift`**:

```bash
process () {
    echo "first arg: $1, total args: $#"
    shift                     # drop $1, shift $2→$1, $3→$2, etc.
    echo "now first arg: $1"
    echo "all remaining: $*"
}
```

**Practice:** `S-tier/list-ops` is directly about writing your own reusable functions (map/filter/reduce-style operations) from scratch.

---

### 11. Reading Input

```bash
read -r name                      # read one line of stdin into $name (-r: don't interpret backslashes)
read -r -p "Name? " name           # with a prompt
read -r -s -p "Password: " pass    # -s: silent, don't echo typed characters
IFS=',' read -r a b c <<< "$line"  # split on commas into three variables

while IFS= read -r line; do
    echo "processing: $line"
done < input.txt                    # canonical "read a file line by line" pattern
```

**Gotcha**: always use `while IFS= read -r line`, not `while read line` — without `-r`, backslashes get interpreted/eaten; without `IFS=`, leading/trailing whitespace on each line gets stripped.

---

### 12. Error Handling & Debugging `[deep]`

#### The safety-net flags

```bash
set -e            # exit immediately if any command exits nonzero
set -u            # error on use of an unset variable, instead of silently treating it as ""
set -o pipefail   # a pipeline's exit status is the last NONZERO exit in it, not just the last command
set -euo pipefail # all three combined — the standard production-script opener, used throughout this repo
```

**Gotchas with `set -e`**: it does NOT trigger inside `if cmd; then`, inside `cmd || true`, inside the condition of `while`/`until`, or for every command in a pipeline unless `pipefail` is also set. It's a safety net, not a guarantee — test failure paths explicitly rather than assuming `-e` alone catches everything.

#### Trapping signals and cleanup

```bash
trap 'echo "cleaning up"; rm -f "$tmpfile"' EXIT     # runs on any exit — normal, error, or signal
trap 'echo "interrupted"; exit 1' INT TERM            # runs on Ctrl-C (INT) or `kill` (TERM)
```

`trap ... EXIT` is the standard pattern for guaranteed cleanup (deleting temp files, releasing locks) regardless of *how* the script ends.

#### Validating input and raising errors

```bash
main () {
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 <input>" >&2   # errors go to STDERR, not stdout — see chapter 6
        exit 1
    fi
}
```

#### Debugging tools

```bash
bash -n script.sh          # syntax check only — parses the script without running it
bash -x script.sh          # trace mode — prints every command before executing it
set -x                     # turn on tracing from a point inside the script; set +x to turn off
set -o functrace           # extend tracing into function calls too
```

Step through logic manually by inserting `echo "DEBUG: var=$var" >&2` at suspicious points, or wrap a whole section in `set -x ... set +x` to see exactly what bash expands each line to.

#### `set` and `shopt` — shell options

`set -o <option>` toggles POSIX-standard shell behaviors (`errexit`, `nounset`, `pipefail`, `xtrace`, etc. — the long names behind `-e`/`-u`/`-x`). `shopt` toggles bash-specific extras not covered by `set`, e.g. `shopt -s globstar` (enables `**` for recursive globbing) or `shopt -s nullglob` (an unmatched glob expands to nothing instead of the literal pattern).

**Practice:** `S-tier/error-handling` is entirely about this chapter — argument validation and correct exit codes on failure paths.

---

### 13. Processes & Job Control

#### Inspecting processes

| Command | Purpose | Example |
|---|---|---|
| `ps` | Snapshot of running processes | `ps aux` |
| `process-status` (concept) | `ps` output columns: PID, %CPU, %MEM, STAT, COMMAND | |
| `top` | Live, auto-refreshing process/resource view | `top` |
| `pgrep` / `pkill` | Find / kill processes by name instead of PID | `pgrep nginx`, `pkill -9 nginx` |
| `kill` | Send a signal to a PID (default: TERM) | `kill -9 1234` (SIGKILL, ungraceful) |
| `killall` | Kill by process name (careful — kills ALL matches) | `killall node` |

#### Job control (foreground/background within your own shell)

```bash
long_task &          # start in background, shell prompt returns immediately
jobs                 # list background jobs in this shell session
fg %1                # bring job 1 to foreground
bg %1                # resume a stopped job in the background
wait                 # block until all background jobs finish (or `wait $pid` for one)
nohup long_task &     # keep running even after the terminal/shell closes
disown -h %1          # detach a job so it survives the shell exiting, without nohup
```

#### Subshells `[deep — this one's worth understanding properly]`

A subshell is a child copy of the current shell: it inherits variables but changes to them (new variables, `cd`, `export`) don't propagate back to the parent.

```bash
(cd /tmp && rm -f scratch.txt)   # parens = explicit subshell — the cd doesn't affect your actual shell
pwd                               # still your original directory

echo "start" | (read -r x; echo "in subshell: $x")   # the RIGHT side of a pipe is ALSO a subshell
```

This is exactly why the "counter incremented inside a piped `while read` loop stays 0" gotcha in chapter 6 happens — it's running in a subshell.

#### Timing and delays

```bash
time some_command        # measure how long a command takes (real/user/sys time)
timeout 5s some_command   # kill the command if it hasn't finished in 5 seconds
sleep 2                   # pause for 2 seconds — also accepts m/h/d suffixes: sleep 1m
```

**Practice:** `B-tier/two-bucket` is a state-space search, conceptually similar to how you'd reason about tracking multiple running processes' states.

---

### 14. Scheduling & System Services

| Command | Purpose | Example |
|---|---|---|
| `crontab -e` | Edit your scheduled recurring jobs | `crontab -e` → `0 2 * * * /path/backup.sh` (2am daily) |
| `systemctl` | Control systemd services (start/stop/enable/status) | `systemctl status nginx` |
| `service` | Older SysV-style service control (many distros alias it onto systemctl) | `service nginx restart` |
| `journalctl` | Query the systemd journal (logs) | `journalctl -u nginx -f` |
| `syslog` (concept) | The traditional Unix system logging facility, often at `/var/log/syslog` | |
| `logwatch` | Automated log summarization/reporting tool | `logwatch --detail high` |
| `sysctl` | Read/write kernel runtime parameters | `sysctl vm.swappiness` |
| `shutdown` | Power off or reboot | `sudo shutdown -h now` |
| `mount` / `umount` | Attach/detach a filesystem | `mount /dev/sdb1 /mnt` |
| `df` | Disk space usage per filesystem | `df -h` |
| `du` | Disk usage of files/directories | `du -sh ./*` |
| `free` | Memory usage (Linux) | `free -h` |
| `iostat` / `vmstat` | I/O and virtual-memory statistics over time | `vmstat 2 5` |
| `lsof` | List open files (and by extension, open network sockets, who's using a file) | `lsof -i :8080` |

Cron syntax reminder: `minute hour day-of-month month day-of-week command` — `*` means "every".

---

### 15. Users, Permissions & Security

| Command | Purpose | Example |
|---|---|---|
| `sudo` | Run a single command as another user (usually root) | `sudo apt update` |
| `su` | Switch to another user's full session | `su - username` |
| `whoami` | Current effective username | `whoami` |
| `who` | Who's currently logged in | `who` |
| `whois` | Domain/IP registration lookup (network admin, not local users) | `whois example.com` |
| `umask` | Default permission mask (see chapter 3) | `umask 022` |

**Gotcha**: `sudo` runs one command with elevated privileges and returns to your normal shell; `su` starts a whole new shell session as that user. Scripts should almost always use `sudo` for the specific privileged step, not run the entire script as root.

---

### 16. Compression & Archiving

| Command | Purpose | Example |
|---|---|---|
| `tar` | Bundle files into an archive (traditionally paired with a compressor) | `tar -czvf out.tar.gz dir/` (create, gzip, verbose, file), `tar -xzvf out.tar.gz` (extract) |
| `gzip` / `gunzip` | Compress/decompress a single file (`.gz`) | `gzip file.txt`, `gunzip file.txt.gz` |
| `bzip2` / `xz` | Alternative compressors, better ratio than gzip, slower | `xz file.txt` |
| `zip` / `unzip` | Cross-platform archive format (unlike tar, bundles + compresses in one step) | `zip -r out.zip dir/`, `unzip out.zip` |

`tar` flag mnemonic: **c**reate / e**x**tract / **t**list, always with **v**erbose and **f** file (which must come last since it takes the filename argument immediately after it).

---

### 17. Networking

| Command | Purpose | Example |
|---|---|---|
| `curl` | Transfer data to/from a URL — the default tool for hitting HTTP APIs from a script | `curl -sS -o out.json https://api.example.com/data` |
| `wget` | Download files from a URL, better suited to recursive/resumable downloads than curl | `wget -c https://example.com/file.iso` |
| `ssh` | Remote shell login | `ssh user@host` |
| `ssh-keygen` | Generate an SSH keypair | `ssh-keygen -t ed25519` |
| `scp` | Copy files over SSH | `scp file.txt user@host:/path/` |
| `rsync` | Efficient file sync (only transfers diffs), also works over SSH | `rsync -avz src/ user@host:/dst/` |
| `nc` (netcat) | Raw TCP/UDP read/write — quick connectivity tests, simple listeners | `nc -zv host 443` (port check) |
| `netstat` | Network connections/listening ports (largely superseded by `ss` on Linux) | `netstat -tulpn` |
| `ping` | ICMP reachability test | `ping -c 4 example.com` |
| `ifconfig` / `ip` | Show/configure network interfaces (`ip` is the modern Linux tool, `ifconfig` is legacy/macOS) | `ip addr show` |
| `nslookup` / `dig` | DNS lookups | `dig example.com +short` |
| `remote-execution` (concept) | Running a command on a remote host without a full interactive login | `ssh user@host 'uptime'` |

**Gotcha**: `curl` doesn't fail (nonzero exit) on an HTTP 404/500 by default — it successfully "curled" an error page. Use `curl -f` (`--fail`) in scripts so a bad HTTP status becomes a real exit-code failure your `set -e` will catch.

---

### 18. Package Managers

| Command | Distro/OS | Example |
|---|---|---|
| `apt` | Debian/Ubuntu | `sudo apt update && sudo apt install <pkg>` |
| `dnf` | Fedora/RHEL (successor to `yum`) | `sudo dnf install <pkg>` |
| `pacman` | Arch Linux | `sudo pacman -S <pkg>` |
| `brew` | macOS (Homebrew) — installs into its own prefix, not system dirs | `brew install <pkg>` |

Scripts meant to be portable across distros shouldn't assume any one of these is present — detect with `command -v apt`, `command -v dnf`, etc., or document the target OS explicitly.

---

### 19. Editors

| Editor | Notes |
|---|---|
| `vi` / `vim` | Modal editor (insert vs. normal mode) — ubiquitous on servers, worth knowing at least `i` (insert), `Esc`, `:wq` (save & quit), `:q!` (quit without saving) |
| `emacs` | Alternative full-featured editor, non-modal, heavy on chorded keybindings (`Ctrl`+`Alt` combos) |
| Basic editor operations | Create a file, print/view it, modify and save — the universal editing loop regardless of which editor |

Knowing minimal `vi`/`vim` survival commands is close to mandatory for ops work — you will eventually SSH into a box with nothing else installed.

#### Vim normal-mode cheat sheet

Everything below runs in **normal mode** (press `Esc` to get there from insert mode). Counts work as a prefix on most of these — `3dd` deletes 3 lines, `5j` moves down 5 lines.

**Modes**

| Key | Effect |
|---|---|
| `i` | insert before cursor |
| `a` | insert (append) after cursor |
| `I` | insert at start of line |
| `A` | insert (append) at end of line |
| `o` | open a new line below and insert |
| `O` | open a new line above and insert |
| `Esc` | back to normal mode |
| `v` | visual mode (character-wise select) |
| `V` | visual line mode (whole-line select) |
| `Ctrl-v` | visual block mode (column select) |

**Movement**

| Key | Effect |
|---|---|
| `h` `j` `k` `l` | left / down / up / right |
| `w` | jump to start of next word |
| `b` | jump to start of previous word |
| `e` | jump to end of current/next word |
| `0` | move to the beginning of the line (column 0, ignores indentation) |
| `^` | move to the first non-blank character of the line |
| `$` | move to the end of the line |
| `gg` | move to the beginning of the file (first line) |
| `G` (i.e. `Shift+g`) | move to the end of the file (last line) |
| `{n}G` or `:{n}` | jump to line number `n`, e.g. `42G` |
| `Ctrl-d` / `Ctrl-u` | scroll half a page down / up |
| `Ctrl-f` / `Ctrl-b` | scroll a full page forward / backward |
| `%` | jump to the matching bracket/paren/brace |
| `*` / `#` | jump to next / previous occurrence of the word under cursor |

**Editing & deleting**

| Key | Effect |
|---|---|
| `dd` | delete (cut) the current line |
| `{n}dd` | delete `n` lines, e.g. `3dd` |
| `dw` | delete to the start of the next word |
| `d$` (or `D`) | delete to the end of the line |
| `d0` | delete to the beginning of the line |
| `x` | delete the character under the cursor |
| `X` | delete the character before the cursor |
| `yy` (or `Y`) | yank (copy) the current line |
| `{n}yy` | yank `n` lines |
| `p` | paste after the cursor / below the current line |
| `P` | paste before the cursor / above the current line |
| `u` | undo |
| `Ctrl-r` | redo |
| `.` | repeat the last change — very useful chained after a search |
| `cc` | change (delete + insert) the current line |
| `cw` | change to the end of the current word |
| `r{char}` | replace a single character under the cursor |
| `~` | toggle case of the character under the cursor |
| `J` | join the current line with the next line |

**Search & replace**

| Key | Effect |
|---|---|
| `/pattern` | search forward for `pattern` |
| `?pattern` | search backward for `pattern` |
| `n` / `N` | repeat last search, same direction / opposite direction |
| `:%s/old/new/g` | replace all occurrences of `old` with `new` in the whole file |
| `:s/old/new/g` | replace all occurrences on the current line only |

**Saving & quitting**

| Key | Effect |
|---|---|
| `:w` | write (save) |
| `:q` | quit (fails if there are unsaved changes) |
| `:wq` (or `ZZ`) | save and quit |
| `:q!` | quit and discard unsaved changes |
| `:x` | save (only if modified) and quit |

---

### 20. Terminal Multiplexing & Sessions

| Command | Purpose | Example |
|---|---|---|
| `tmux` | Terminal multiplexer — multiple panes/windows in one session, and crucially, **sessions survive an SSH disconnect** | `tmux new -s work`, `Ctrl-b d` (detach), `tmux attach -t work` |
| `tty` | Print the current terminal device path | `tty` |
| `tabs` | Set tab-stop width for the terminal | `tabs 4` |
| `mesg` | Allow/deny other users writing directly to your terminal (`write`/`wall`) | `mesg n` |
| `logout` | End a login shell session | `logout` |

`tmux` (or `screen`) is the standard answer to "my long-running remote command died when my SSH connection dropped" — run it inside a tmux session and it keeps running even if you disconnect.

---

### 21. Finding Things

| Command | Purpose | Example |
|---|---|---|
| `find` | Search the filesystem by name/type/time/size, recursively | `find . -name "*.log" -mtime +7` (files older than 7 days) |
| `locate` | Search a prebuilt filename index — much faster than `find`, but can be stale until the index updates | `locate nginx.conf` |
| `which` | Which executable on `$PATH` would run for this command name | `which python3` |

`find` is far more powerful than `locate`/`which` — it can filter by permissions, size, modification time, and act on results directly with `-exec` (though see the caution below).

**Gotcha**: `find ... -exec rm {} \;` is real and useful, but never build the command being executed from untrusted/dynamic input — that's a command-injection footgun. Prefer `-delete` for simple deletions, or `-exec cmd {} +` (batches arguments, faster than `\;` which execs once per file).

---

### 22. Aliases, Customization & Wrap-up

```bash
alias ll='ls -lah'                # define, valid for the current shell
unalias ll                        # remove it
type ll                            # confirm it's registered as an alias
```

Put persistent aliases in `~/.bashrc` (interactive non-login shells) — aliases are an *interactive convenience only*; never rely on an alias existing inside a script, since scripts run non-interactively and don't expand aliases by default.

**General tips**
- Quote variable expansions by default (`"$var"`, `"${arr[@]}"`) — unquoted expansion is the single most common source of bash bugs (word-splitting, globbing).
- Prefer `[[ ]]` over `[ ]` in bash-specific scripts; only drop to `[ ]`/`test` if you specifically need POSIX `sh` portability.
- Prefer `$(...)` over backticks for command substitution — it nests without escaping.
- Run `shellcheck script.sh` if it's available — it catches most of the gotchas in this notebook automatically.

---

### Where to practice

This repo's exercises (see `bash/CLAUDE.md` for the tier system) are a direct extension of this notebook:

| Concept area | Exercises |
|---|---|
| Exit codes / error handling (ch. 2, 12) | [S-tier/error-handling](S-tier/error-handling/) |
| Arrays, string manipulation (ch. 7) | [A-tier/reverse-string](A-tier/reverse-string/), [A-tier/anagram](A-tier/anagram/), [A-tier/rectangles](A-tier/rectangles/), [S-tier/transpose](S-tier/transpose/), [S-tier/nucleotide-count](S-tier/nucleotide-count/) |
| Arithmetic (ch. 7) | [A-tier/prime-factors](A-tier/prime-factors/), [B-tier/armstrong-numbers](B-tier/armstrong-numbers/), [B-tier/difference-of-squares](B-tier/difference-of-squares/) |
| Associative arrays (ch. 7) | [S-tier/tournament](S-tier/tournament/), [S-tier/word-count](S-tier/word-count/), [A-tier/resistor-color](A-tier/resistor-color/) |
| Control flow / comparisons (ch. 8, 9) | [A-tier/robot-simulator](A-tier/robot-simulator/), [A-tier/wordy](A-tier/wordy/), [S-tier/sublist](S-tier/sublist/) |
| Functions (ch. 10) | [S-tier/list-ops](S-tier/list-ops/) |
| Bitwise / VLQ encoding (ch. 7, 8) | [S-tier/variable-length-quantity](S-tier/variable-length-quantity/) |
| Arrays as a stack (ch. 7) | [S-tier/matching-brackets](S-tier/matching-brackets/) |
| grep / regex / text processing (ch. 5) | [S-tier/grep](S-tier/grep/), [S-tier/phone-number](S-tier/phone-number/), [S-tier/markdown](S-tier/markdown/) |

Read a chapter, then go solve the matching exercise — that loop is the fastest way to actually retain this.

---

## Part 3 — Production Checklist

### 1. Structure and Hygiene

-   [ ] Script starts with `#!/usr/bin/env bash`
-   [ ] Uses `set -euo pipefail`
-   [ ] No undefined variables used
-   [ ] Logic organized inside functions
-   [ ] `main()` function exists
-   [ ] No large logic blocks in global scope

### 2. Input Handling

-   [ ] Argument count validated
-   [ ] Empty input handled
-   [ ] Invalid input rejected
-   [ ] All variables quoted `"${var}"`
-   [ ] Uses `"$@"` instead of `$*`
-   [ ] Provides `-h`/`--help` usage text


### 3. Stream and Pipeline Design

-   [ ] Script works with stdin
-   [ ] No hardcoded file paths
-   [ ] Output contains only result data
-   [ ] Debug logs go to stderr
-   [ ] Script can be chained in pipelines


### 4. Text Processing Discipline

-   [ ] Correct tool used for parsing task
-   [ ] Avoids unnecessary subshells
-   [ ] Avoids useless pipelines
-   [ ] Loop logic is explicit and readable


### 5. Logic Robustness

-   [ ] Handles edge cases
-   [ ] Handles long input
-   [ ] Handles special characters
-   [ ] Exit codes are meaningful
-   [ ] Success returns exit 0
-   [ ] Exit codes follow a documented, stable contract (e.g. 0=success, 1=usage error, 2=runtime error) callers can rely on


### 6. Testability

-   [ ] Works with argument input
-   [ ] Works with pipe input
-   [ ] Works with file redirection
-   [ ] Can run with `set -x` debug mode


### 7. Portability

-   [ ] Avoids non‑portable shell features
-   [ ] Avoids unnecessary external dependencies
-   [ ] Runs in minimal container environment
-   [ ] Passes `shellcheck` with no unresolved warnings



### 8. Code Quality

-   [ ] Variable names are descriptive
-   [ ] Code prioritizes readability
-   [ ] No overly clever one‑liners
-   [ ] Comments explain why, not what



### 9. Security and Secrets Handling

-   [ ] No hardcoded secrets, tokens, or credentials
-   [ ] Secrets are never echoed or logged, including under `set -x`
-   [ ] No `eval` or dynamically-built commands from untrusted/unsanitized input
-   [ ] Temp files created with `mktemp`, never a predictable path
-   [ ] Script does not require root/sudo unless the specific step needs it


### 10. Idempotency and Operational Resilience

Before marking done, confirm:

-   [ ] Re-running the script is safe — no duplicate or corrupting side effects
-   [ ] External calls (network, subprocess) have a timeout
-   [ ] Transient failures are retried with backoff where appropriate
-   [ ] Concurrent runs are guarded against (e.g. `flock`) if triggered by cron/CI
-   [ ] Traps `INT`/`TERM` for graceful shutdown, not just `EXIT`
-   [ ] Script can run in cron
-   [ ] Script can run in CI
-   [ ] Failure does not corrupt pipeline
-   [ ] Script can be reused


### 11. Completion Criteria

A script is considered complete only if:

-   [ ] Passes Exercism tests
-   [ ] Passes this checklist
-   [ ] Author understands every line
-   [ ] Author can explain logic clearly
