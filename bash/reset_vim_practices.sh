#!/usr/bin/env bash
#
# Regenerates a pristine vim practice lab file from the template embedded
# in this script. The template is the single source of truth — the .txt
# file it writes is a disposable, generated artifact. Run this any time
# you want to reset practice progress back to a known-good starting state.

set -euo pipefail

readonly DEFAULT_OUTPUT="vim_practices.txt"

usage() {
    cat <<'USAGE'
Usage: reset_vim_practices.sh [-f|--force] [-h|--help] [output_file]

Write a pristine vim practice lab to output_file (default:
vim_practices.txt in the current directory), overwriting any in-progress
edits so you can restart the lab from scratch.

Options:
  -f, --force   overwrite output_file even if it already exists
  -h, --help    show this help text and exit

Exit codes:
  0  file written
  1  usage error (bad flag)
  2  output_file exists and -f/--force was not given
USAGE
}

write_template() {
    cat <<'TEMPLATE'
=====================================================================
VIM PRACTICE FILE
Each section below states a GOAL (the command to drill) followed by
a TASK block of content shaped to exercise exactly that command.
Work top to bottom; do not skip the setup lines inside each task.

Made a mess practicing? Re-run reset_vim_practices.sh to restore this
file to exactly this starting state.
=====================================================================

---------------------------------------------------------------------
GOAL 1: gg / G  — jump to the start / end of the file
TASK: from anywhere below this line, press `gg` to land back on line 1,
then press `G` to land on the very last line of this file.
---------------------------------------------------------------------

---------------------------------------------------------------------
GOAL 2: {n}G or :{n}  — jump to a specific line number
TASK: jump directly to line 30, then to line 45, then to line 60.
---------------------------------------------------------------------
line 20
line 21
line 22
line 23
line 24
line 25
line 26
line 27
line 28
line 29
line 30   <-- target A
line 31
line 32
line 33
line 34
line 35
line 36
line 37
line 38
line 39
line 40
line 41
line 42
line 43
line 44
line 45   <-- target B
line 46
line 47
line 48
line 49
line 50
line 51
line 52
line 53
line 54
line 55
line 56
line 57
line 58
line 59
line 60   <-- target C

---------------------------------------------------------------------
GOAL 3: 0 / ^ / $  — beginning of line (col 0), first non-blank, end of line
TASK: on each line below, practice all three: `0`, `^`, `$`.
Notice how `0` and `^` differ only when a line has leading whitespace.
---------------------------------------------------------------------
no leading whitespace on this line, so 0 and ^ land in the same place
    this line has leading spaces — 0 goes to col 0, ^ skips to "this"
        deeply indented line — try 0 then ^ then $ and compare cursor spots
tail whitespace on this line too

---------------------------------------------------------------------
GOAL 4: w / b / e  — jump forward/back by word, jump to end of word
TASK: place the cursor at the start of the line and hop across it
using only w, b, and e — no arrow keys.
---------------------------------------------------------------------
quick brown fox jumps over the lazy dog near the old wooden fence
one two three four five six seven eight nine ten eleven twelve

---------------------------------------------------------------------
GOAL 5: dd / {n}dd  — delete whole lines
TASK: delete the three "DELETE ME" lines below using dd, then delete
the block of five "BATCH DELETE" lines in one shot with 5dd.
---------------------------------------------------------------------
keep this line - marker A
DELETE ME - line 1
keep this line - marker B
DELETE ME - line 2
keep this line - marker C
DELETE ME - line 3
keep this line - marker D
BATCH DELETE 1
BATCH DELETE 2
BATCH DELETE 3
BATCH DELETE 4
BATCH DELETE 5
keep this line - marker E

---------------------------------------------------------------------
GOAL 6: dw / d$ (D) / d0  — delete to next word / to end of line / to start of line
TASK: on line A, put cursor on "REMOVE" and use dw to delete just that word.
On line B, put cursor right before "cut everything after this" and use D.
On line C, put cursor at the end and use d0 to delete back to column 0.
---------------------------------------------------------------------
line A: keep REMOVE this keep keep keep
line B: keep this part, cut everything after this point right here
line C: delete everything before the cursor which starts right here END

---------------------------------------------------------------------
GOAL 7: x / X  — delete char under cursor / delete char before cursor
TASK: fix the typos below by deleting the extra letters.
---------------------------------------------------------------------
helllo world
wrongg spelling
xxextra chars at the start

---------------------------------------------------------------------
GOAL 8: yy / {n}yy / p / P  — yank and paste lines
TASK: yank line ALPHA and paste it directly below line BETA (p),
then yank the 3-line block BLOCK-1..BLOCK-3 with 3yy and paste it
above line GAMMA (P).
---------------------------------------------------------------------
line ALPHA - yank this one
line BETA - paste ALPHA right after this
BLOCK-1 - yank this trio
BLOCK-2 - yank this trio
BLOCK-3 - yank this trio
line GAMMA - paste the trio right above this

---------------------------------------------------------------------
GOAL 9: u / Ctrl-r  — undo / redo
TASK: delete the line below with dd, confirm it's gone, press u to
bring it back, then press Ctrl-r to redo the deletion.
---------------------------------------------------------------------
this line exists so you can delete it and then undo/redo the change

---------------------------------------------------------------------
GOAL 10: cc / cw / r / ~  — change line / change word / replace char / toggle case
TASK: use cc to rewrite line A entirely. Use cw on "wrong" in line B to
replace it with "right". Use r to fix the single bad character marked
with * in line C. Use ~ to fix the CaSe mistakes in line D.
---------------------------------------------------------------------
line A: this entire line should be replaced with something new
line B: this word is wrong and needs fixing
line C: the*letter marked with a star is incorrect
line D: tHIS liNE haS RandOM cAse mistAKES

---------------------------------------------------------------------
GOAL 11: J  — join the current line with the next line
TASK: join these three lines into a single line using J twice.
---------------------------------------------------------------------
this is the first fragment
this is the second fragment
this is the third fragment

---------------------------------------------------------------------
GOAL 12: .  — repeat the last change
TASK: delete the word "TARGET" on the first line with dw, then move to
each subsequent line and repeat the deletion with just `.` — no retyping.
---------------------------------------------------------------------
remove the TARGET word from this line
remove the TARGET word from this line too
and also remove the TARGET word from here
one more line with a TARGET word to remove

---------------------------------------------------------------------
GOAL 13: %  — jump to the matching bracket/paren/brace
TASK: place the cursor on each opening symbol and press % to jump to
its matching closer, then % again to jump back.
---------------------------------------------------------------------
function call: process(arg1, arg2, [nested, list, {key: value}], arg3)
array test: [1, 2, 3, [4, 5, [6, 7]], 8, 9]
brace test: { outer { middle { inner } middle } outer }

---------------------------------------------------------------------
GOAL 14: /pattern and ?pattern, n / N  — search forward/backward, repeat
TASK: search forward for "needle" with /needle, press n to jump to the
next match, then search backward with ?needle and press N to reverse
direction.
---------------------------------------------------------------------
haystack haystack needle haystack haystack
haystack needle haystack haystack needle
haystack haystack haystack needle haystack

---------------------------------------------------------------------
GOAL 15: * and #  — jump to next/previous occurrence of word under cursor
TASK: put the cursor on "token" anywhere below and press * to jump to
the next occurrence, then # to jump to the previous one.
---------------------------------------------------------------------
token alpha token beta gamma token delta token epsilon token

---------------------------------------------------------------------
GOAL 16: :%s/old/new/g  — replace all occurrences in the whole file (buffer)
TASK: run :%s/apple/orange/g on the lines below and confirm every
"apple" becomes "orange", including multiple per line.
---------------------------------------------------------------------
apple pie and apple juice
fresh apple, dried apple, apple sauce
no fruit mentioned on this line
apple slices on a plate with more apple on the side

---------------------------------------------------------------------
GOAL 17: :s/old/new/g  — replace all occurrences on the CURRENT line only
TASK: with the cursor on the line below, run :s/cat/dog/g and confirm
only that line changes, not the others.
---------------------------------------------------------------------
cat cat cat cat cat
cat cat cat cat cat
cat cat cat cat cat

---------------------------------------------------------------------
GOAL 18: v / V / Ctrl-v  — visual, visual-line, visual-block selection
TASK: use `v` to select just the word "select-me" on line A and delete
it. Use `V` to select lines B-D as whole lines and delete them. Use
Ctrl-v to select the leading "###" column across lines E-G and delete
just that column.
---------------------------------------------------------------------
line A: character mode select-me here for practice
line B: whole line selection target one
line C: whole line selection target two
line D: whole line selection target three
###line E: block-select this leading marker
###line F: block-select this leading marker
###line G: block-select this leading marker

---------------------------------------------------------------------
GOAL 19: i / a / I / A / o / O  — insert-mode entry points
TASK: use `I` to insert "START: " at the beginning of line A.
Use `A` to append " :END" at the end of line B.
Use `o` below line C to open a new line beneath it.
Use `O` above line D to open a new line above it.
Use `i`/`a` on line E to fix the gap in "mis|take".
---------------------------------------------------------------------
line A: needs a prefix added at the very front
line B: needs a suffix added at the very end
line C: a new line should appear directly below this one
line D: a new line should appear directly above this one
line E: watch for the mis take split in this word

---------------------------------------------------------------------
GOAL 20: Ctrl-d / Ctrl-u / Ctrl-f / Ctrl-b  — scroll half-page / full-page
TASK: this block is long on purpose — use Ctrl-d to scroll down a half
page, Ctrl-u to scroll back up a half page, Ctrl-f for a full page
forward, and Ctrl-b for a full page back.
---------------------------------------------------------------------
filler line 001
filler line 002
filler line 003
filler line 004
filler line 005
filler line 006
filler line 007
filler line 008
filler line 009
filler line 010
filler line 011
filler line 012
filler line 013
filler line 014
filler line 015
filler line 016
filler line 017
filler line 018
filler line 019
filler line 020
filler line 021
filler line 022
filler line 023
filler line 024
filler line 025
filler line 026
filler line 027
filler line 028
filler line 029
filler line 030
filler line 031
filler line 032
filler line 033
filler line 034
filler line 035
filler line 036
filler line 037
filler line 038
filler line 039
filler line 040

=====================================================================
END OF PRACTICE FILE — re-run reset_vim_practices.sh (optionally with
-f) at any time to restore this exact starting state.
=====================================================================
TEMPLATE
}

main() {
    local force=0
    local output="${DEFAULT_OUTPUT}"

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
                echo "reset_vim_practices.sh: unknown option: $1" >&2
                usage >&2
                exit 1
                ;;
            *)
                output="$1"
                shift
                ;;
        esac
    done

    if [[ -e "${output}" && "${force}" -ne 1 ]]; then
        echo "reset_vim_practices.sh: '${output}' already exists — use -f/--force to overwrite" >&2
        exit 2
    fi

    write_template > "${output}"
    echo "reset_vim_practices.sh: wrote pristine lab to ${output}" >&2
}

main "$@"
