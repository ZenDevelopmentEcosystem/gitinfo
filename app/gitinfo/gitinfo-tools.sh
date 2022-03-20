#!/usr/bin/env bash

(return 0 2>/dev/null) || set -eu

# returns list of all tool names in lower case letters based on tools script file.
function get-tools() {
    while IFS= read -r tools_file
    do
       basename "${tools_file,,}" .sh
    done < <(find "${GITINFO_BASE_DIR}/tools" -type f -name '*.sh' | sort -u)
}

function source-tools() {
    while IFS= read -r tools_file
    do
        # shellcheck source=/dev/null
        source "${tools_file}"
    done < <(find "${GITINFO_BASE_DIR}/tools" -type f -name '*.sh')
}
