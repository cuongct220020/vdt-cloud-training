#!/usr/bin/env bash
#
# Regenerates a pristine redirection/pipes/substitution practice lab
# (sample data files + a task list) from the templates embedded in this
# script. The templates are the single source of truth — the lab
# directory they write is a disposable, generated artifact. Run this
# any time you want to reset practice progress back to a known-good
# starting state, same pattern as reset_vim_practices.sh.

set -euo pipefail

readonly DEFAULT_DIR="redirects_pipelines_lab"

# Files this script owns/generates. Anything else found in output_dir
# on a forced reset is considered lab-session cruft (out.txt, both.txt,
# errors_only.log, stdout_count.txt, ...) and gets removed.
readonly KEEP_FILES=(
    "mixed_output.sh"
    "access.log"
    "list_a.txt"
    "list_b.txt"
    "raw_words.txt"
    "README.md"
)

usage() {
    cat <<'USAGE'
Usage: reset_redirects_pipelines_lab.sh [-f|--force] [-h|--help] [output_dir]

Write a pristine redirection/pipes/substitution practice lab to
output_dir (default: redirects_pipelines_lab in the current directory).
If output_dir already exists, -f/--force removes any stray temp files
you created while working through the lab (out.txt, both.txt,
errors_only.log, etc.) and rewrites the known fixtures, including
README.md, from scratch.

The lab covers: output redirection (>, >>), input redirection (<),
error redirection (2>, 2>&1, &>, /dev/null), pipes, tee, here-docs,
here-strings, command substitution $(...), process substitution
<(...) and >(...), the pipe-subshell gotcha, and pipefail semantics.

Options:
  -f, --force   overwrite output_dir even if it already exists
  -h, --help    show this help text and exit

Exit codes:
  0  lab written
  1  usage error (bad flag)
  2  output_dir exists and -f/--force was not given
USAGE
}

write_mixed_output() {
    cat <<'EOF'
#!/usr/bin/env bash
#
# Prints some lines to stdout, some to stderr, then exits nonzero —
# fixture for redirection and pipefail practice.

set -uo pipefail

echo "INFO: starting job"
echo "INFO: step 1 complete"
echo "ERROR: failed to connect to database" >&2
echo "INFO: step 2 complete"
echo "ERROR: disk quota exceeded" >&2
echo "INFO: job finished with errors"

exit 1
EOF
}

write_access_log() {
    cat <<'EOF'
2026-08-01 09:00:01 INFO  server started on port 8080
2026-08-01 09:00:15 INFO  health check passed
2026-08-01 09:01:02 WARN  slow response time: 850ms
2026-08-01 09:02:11 ERROR failed to reach upstream api
2026-08-01 09:02:45 INFO  retry succeeded
2026-08-01 09:03:30 ERROR database connection timeout
2026-08-01 09:04:00 INFO  cache warmed
2026-08-01 09:05:12 WARN  memory usage above 80%
2026-08-01 09:06:20 ERROR failed to reach upstream api
2026-08-01 09:07:01 INFO  request completed in 120ms
2026-08-01 09:08:44 WARN  slow response time: 910ms
2026-08-01 09:09:15 ERROR disk write failed
2026-08-01 09:10:02 INFO  scheduled backup started
2026-08-01 09:11:30 INFO  scheduled backup finished
2026-08-01 09:12:05 ERROR failed to reach upstream api
EOF
}

write_list_a() {
    cat <<'EOF'
banana
cherry
date
apple
fig
grape
EOF
}

write_list_b() {
    cat <<'EOF'
banana
cherry
date
apple
kiwi
grape
EOF
}

write_raw_words() {
    cat <<'EOF'
dog
cat
dog
bird
cat
dog
fish
bird
cat
dog
EOF
}

write_readme() {
    cat <<'TASKS_DOC'
# Redirection / Pipes / Substitution Practice Lab

Each section states a **Goal** (the concept to drill) followed by a
**Task** naming the real commands to run against the sample files in
this directory. Run them for real in your terminal — don't just read
them.

> Made a mess (temp files everywhere, renamed fixtures)? Re-run
> `./reset_redirects_pipelines_lab.sh -f` to restore this whole
> directory to exactly this starting state.

## Files in this lab

| File | Purpose |
|---|---|
| `mixed_output.sh` | prints INFO to stdout, ERROR to stderr, exits 1 |
| `access.log` | sample log lines (INFO/WARN/ERROR) for pipes |
| `list_a.txt` | unsorted fruit list, for diff/process substitution |
| `list_b.txt` | unsorted fruit list, differs from list_a in 1 line |
| `raw_words.txt` | duplicated words, for `sort \| uniq -c` practice |

## Goals

1. [`>` — redirect stdout to a new file](#goal-1--redirect-stdout-to-a-new-file-overwrite)
2. [`>>` — append stdout instead of overwriting](#goal-2--append-stdout-instead-of-overwriting)
3. [`<` — feed a file in as stdin](#goal-3--feed-a-file-in-as-stdin)
4. [`2>` — redirect only stderr](#goal-4-2--redirect-only-stderr)
5. [redirection order](#goal-5-redirection-order--out-21-vs-21--out)
6. [`&>` — redirect both streams](#goal-6--bash-shortcut-for-redirecting-both-streams)
7. [`/dev/null` — discard output](#goal-7-devnull--discard-output-you-dont-want)
8. [`cmd1 | cmd2` — pipes](#goal-8-cmd1--cmd2--pipes)
9. [`tee` — split a stream](#goal-9-tee--split-a-stream-to-a-file-and-stdout-at-once)
10. [here-doc (`<<EOF`)](#goal-10-here-doc-eof--multi-line-input-without-a-separate-file)
11. [here-string (`<<<`)](#goal-11-here-string--feed-one-string-as-stdin)
12. [`$(...)` — command substitution](#goal-12--command-substitution)
13. [`<(...)` — process substitution, input](#goal-13--process-substitution-as-a-virtual-input-file)
14. [`>(...)` — process substitution, output](#goal-14--process-substitution-as-a-virtual-output-target)
15. [the pipe-subshell gotcha](#goal-15-the-pipe-subshell-gotcha)
16. [`pipefail` and pipeline exit codes](#goal-16-pipefail-and-pipeline-exit-codes)

---

### Goal 1: `>` — redirect stdout to a new file (overwrite)

**Task:** run `./mixed_output.sh > out.txt` (ERROR lines still print
to your terminal — only stdout was redirected). Open `out.txt` and
confirm it holds only the INFO lines. Run the exact same command
again and confirm `out.txt` was overwritten, not appended to.

---

### Goal 2: `>>` — append stdout instead of overwriting

**Task:** run `./mixed_output.sh >> out.txt` twice in a row. Confirm
`out.txt` now contains the INFO lines duplicated once per run.

---

### Goal 3: `<` — feed a file in as stdin

**Task:** run `wc -l < access.log` and compare it to
`wc -l access.log` — notice the filename is missing from the first
form's output because `wc` never saw a filename, only an anonymous
stdin stream. Then run `sort < list_a.txt` to sort `list_a.txt` via
stdin instead of passing it as an argument.

---

### Goal 4: `2>` — redirect only stderr

**Task:** run `./mixed_output.sh 2> errors.txt` and confirm the INFO
lines still print to your terminal while only the ERROR lines land in
`errors.txt`.

---

### Goal 5: redirection order — `> out 2>&1` vs `2>&1 > out`

**Task:** run `./mixed_output.sh > both.txt 2>&1` and confirm
`both.txt` holds INFO and ERROR lines together. Then run
`./mixed_output.sh 2>&1 > both2.txt` and confirm ERROR lines print to
your terminal while only INFO lines land in `both2.txt` — same-looking
flags, opposite result, because redirections are applied left to
right and `2>&1` only captures wherever stdout points *at that
moment*.

---

### Goal 6: `&>` — bash shortcut for redirecting both streams

**Task:** run `./mixed_output.sh &> combined.txt` and confirm it
matches Goal 5's first result with less typing.

---

### Goal 7: `/dev/null` — discard output you don't want

**Task:** run `./mixed_output.sh > /dev/null` and confirm only ERROR
lines print. Then run `./mixed_output.sh &> /dev/null` and confirm
nothing prints at all, but `echo $?` right after still shows `1`.

---

### Goal 8: `cmd1 | cmd2` — pipes

**Task:** count ERROR lines with `grep ERROR access.log | wc -l`.
Then get counts per log level with:

```bash
awk '{print $3}' access.log | sort | uniq -c
```

---

### Goal 9: `tee` — split a stream to a file and stdout at once

**Task:** run `grep ERROR access.log | tee errors_only.log | wc -l`
and confirm the count still prints AND `errors_only.log` holds the
matched lines. Re-run using `tee -a errors_only.log` and confirm it
appends instead of overwriting.

---

### Goal 10: here-doc (`<<EOF`) — multi-line input without a separate file

**Task:** pipe a 3-line message into `cat` with a here-doc:

```bash
cat <<EOF
line one
line two
line three
EOF
```

Then set `name=world` and compare:

```bash
cat <<EOF
hi $name
EOF
```

against:

```bash
cat <<'EOF'
hi $name
EOF
```

Confirm the quoted delimiter form does NOT expand `$name` while the
unquoted form does.

---

### Goal 11: here-string (`<<<`) — feed one string as stdin

**Task:** run `tr 'a-z' 'A-Z' <<< "$(head -n1 access.log)"` — a single
line into a command's stdin, no here-doc or temp file needed.

---

### Goal 12: `$(...)` — command substitution

**Task:** capture the ERROR count into a variable with
`error_count=$(grep -c ERROR access.log)` and `echo "$error_count"`.
Then run `lines=$(cat list_a.txt)` followed by `echo "$lines" | wc -l`
and confirm the line count still comes out right even though command
substitution strips trailing newlines.

---

### Goal 13: `<(...)` — process substitution as a virtual input file

**Task:** diff the two fruit lists without creating a temp file:

```bash
diff <(sort list_a.txt) <(sort list_b.txt)
```

Then run `echo <(echo hi)` on its own and look at what it prints —
confirm process substitution works by handing commands a real (if
unusual) file path, not by piping stdin directly.

---

### Goal 14: `>(...)` — process substitution as a virtual output target

**Task:** send `mixed_output.sh`'s two streams through two different
counters in one line, no `tee`, no temp files:

```bash
./mixed_output.sh > >(wc -l > stdout_count.txt) 2> >(wc -l > stderr_count.txt)
```

Confirm both `stdout_count.txt` and `stderr_count.txt` get written.

---

### Goal 15: the pipe-subshell gotcha

> **Note:** this bug is bash-specific. zsh (macOS's default
> interactive shell) runs the last stage of a pipeline in the current
> shell, so typing this straight into a zsh prompt will NOT reproduce
> it. Run `bash` first to drop into an actual bash session, since
> every script in this repo is `#!/usr/bin/env bash` and will hit this
> behavior.

**Task:** inside bash, run this exactly as written and note the final
count is `0`, not the real match count, because the while loop runs in
a subshell and its variable changes don't survive past the pipe:

```bash
count=0
grep ERROR access.log | while read -r line; do count=$((count+1)); done
echo "$count"
```

Now fix it with process substitution instead of a pipe:

```bash
count=0
while read -r line; do count=$((count+1)); done < <(grep ERROR access.log)
echo "$count"
```

---

### Goal 16: `pipefail` and pipeline exit codes

**Task:** run `grep NOTHINGMATCHES access.log | wc -l` then `echo $?`
— notice it prints `0` even though `grep` found nothing, because `$?`
holds `wc`'s exit code (the last command in the pipe), not `grep`'s.
Now run `set -o pipefail` and repeat the same pipeline — confirm `$?`
now reflects `grep`'s nonzero exit status instead.

---

*End of task list — re-run `./reset_redirects_pipelines_lab.sh -f` at
any time to restore this entire directory to this exact starting
state.*
TASKS_DOC
}

clean_stray_files() {
    local dir=$1
    local entry base keep k

    for entry in "${dir}"/*; do
        [[ -e "${entry}" ]] || continue

        base="$(basename "${entry}")"
        keep=0
        for k in "${KEEP_FILES[@]}"; do
            if [[ "${base}" == "${k}" ]]; then
                keep=1
                break
            fi
        done

        if [[ "${keep}" -ne 1 ]]; then
            rm -rf -- "${entry}"
        fi
    done
}

main() {
    local force=0
    local output_dir="${DEFAULT_DIR}"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -f|--force)
                force=1
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -*)
                echo "reset_redirects_pipelines_lab.sh: unknown option: $1" >&2
                usage >&2
                exit 1
                ;;
            *)
                output_dir="$1"
                shift
                ;;
        esac
    done

    if [[ -e "${output_dir}" ]]; then
        if [[ "${force}" -ne 1 ]]; then
            echo "reset_redirects_pipelines_lab.sh: '${output_dir}' already exists — use -f/--force to overwrite" >&2
            exit 2
        fi
        clean_stray_files "${output_dir}"
    fi

    mkdir -p "${output_dir}"

    write_mixed_output > "${output_dir}/mixed_output.sh"
    chmod +x "${output_dir}/mixed_output.sh"
    write_access_log > "${output_dir}/access.log"
    write_list_a > "${output_dir}/list_a.txt"
    write_list_b > "${output_dir}/list_b.txt"
    write_raw_words > "${output_dir}/raw_words.txt"
    write_readme > "${output_dir}/README.md"

    echo "reset_redirects_pipelines_lab.sh: wrote pristine lab to ${output_dir}/" >&2
}

main "$@"
