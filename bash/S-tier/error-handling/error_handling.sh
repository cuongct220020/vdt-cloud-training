#!/usr/bin/env bash
#
# Prints a greeting for exactly one argument (a person's name, which may
# be an empty string); rejects zero or multiple arguments as a usage
# error.

set -euo pipefail


main() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: error_handling.sh <person>"
        exit 1
    fi

    local name=$1
    echo "Hello, ${name}!"
}

main "$@"
