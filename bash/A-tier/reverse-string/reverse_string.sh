#!/usr/bin/env bash

set -euo pipefail

main () {
    input_string=$1

    if [ -z "$input_string" ]; then
        echo "Input is not available..."
        exit 1
    fi

    local string_length=${#input_string}
    local stack=()

    for (( i=0; i < string_length; i++ )); do
        char=${input_string:i:1}
        stack+=("$char")
    done

    local last_index=$(( ${#stack[@]} - 1 ))
    for (( i=last_index; i >= 0; i-- )); do
        echo -n "${stack[i]}"
    done

    echo ""
}

main "$@"