#!/usr/bin/env bash

(return 0 2>/dev/null) || set -eu

GITINFO_BASE_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo "$0")")

REPO_BASE_DIR=${REPO_BASE_DIR:-/gitinfo/repositories}
OUTPUT_BASE_DIR=${OUTPUT_BASE_DIR:-/usr/share/nginx/html}

# shellcheck source=gitinfo-tools.sh
source "${GITINFO_BASE_DIR}/gitinfo-tools.sh"

# shellcheck source=gitinfo-status.sh
source "${GITINFO_BASE_DIR}/gitinfo-status.sh"

# shellcheck source=gitinfo-repositories.sh
source "${GITINFO_BASE_DIR}/gitinfo-repositories.sh"

# shellcheck source=gitinfo-logging.sh
source "${GITINFO_BASE_DIR}/gitinfo-logging.sh"

# $1 - Project Name
# $2 - Repository Path
# $3 - Repository URL
# $4 - Status file
function init-repository() {
    local name=$1
    local repo_path=$2
    local repo_url=$3
    local status_file=$4
    local repo_id=${name,,}

    log-info "Initializing repository ${name}"
    set-base-attributes "${status_file}" "${repo_id}" "${name}" "${repo_url}" "${repo_path}"
    set-branch "${status_file}" "${repo_id}" "n/a"
    set-commit "${status_file}" "${repo_id}" "n/a"

    while IFS= read -r tool
    do
        set-status "${status_file}" "${repo_id}" "${tool}" "notrun"
    done < <(get-tools)
}

function gitinfo-init() {
    local status_file="${OUTPUT_BASE_DIR}/status.json"
    declare -a tools; mapfile -t tools < <(get-tools)

    prepare-status-file "${status_file}"
    set-tools "${status_file}" "${tools[@]}"

    for-each-repository init-repository "${status_file}"

}

(return 0 2>/dev/null) || gitinfo-init
