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
