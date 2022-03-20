#!/usr/bin/env bash

(return 0 2>/dev/null) || set -eu

GITINFO_BASE_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo "$0")")

REPO_BASE_DIR=${REPO_BASE_DIR:-/gitinfo/repositories}
OUTPUT_BASE_DIR=${OUTPUT_BASE_DIR:-/usr/share/nginx/html}
TEMP_DIR=${TEMP_DIR:-/gitinfo/tmp}
TIMEOUT=${TIMEOUT:-600s}

# shellcheck source=gitinfo-tools.sh
source "${GITINFO_BASE_DIR}/gitinfo-tools.sh"

# shellcheck source=gitinfo-status.sh
source "${GITINFO_BASE_DIR}/gitinfo-status.sh"

# shellcheck source=gitinfo-repositories.sh
source "${GITINFO_BASE_DIR}/gitinfo-repositories.sh"

# shellcheck source=gitinfo-logging.sh
source "${GITINFO_BASE_DIR}/gitinfo-logging.sh"

source-tools

# $1 - Repository name
# $1 - Repository ID
# $2 - Repository path
# $3 - Repository URL
# $4 - Status file
function update-repository() {
    local repo_name=$1
    local repo_id=$2
    local repo_path=$3
    local repo_url=$4
    local status_file=$5

    if [ ! -d "${repo_path}" ]; then
        mkdir -p "$(dirname "${repo_path}")"
        git clone --single-branch "${repo_url}" "${repo_path}"
    fi
    set-base-attributes "${status_file}" "${repo_id}" "${repo_name}" "${repo_url}" "${repo_path}"
    (cd "${repo_path}" \
     && git pull --force \
     && set-branch  "${status_file}" "${repo_id}" "$(git rev-parse --abbrev-ref HEAD)" \
     && set-commit "${status_file}" "${repo_id}" "$(git rev-parse --short HEAD)"
    )
}

# $1 - Repository ID
# $2 - Tool name
# $3 - Output dir
# $4 - Status file
function handle-success() {
    local repo_id=$1
    local tool=$2
    local output_dir=$3 #not used
    local status_file=$4
    set-status "${status_file}" "${repo_id}" "${tool}" "success"
}

# $1 - Repository ID
# $2 - Tool name
# $3 - Output dir
# $4 - Status file
function handle-error() {
    local repo_id=$1
    local tool=$2
    local output_dir=$3
    local status_file=$4
    local output_file="${output_dir}/index.html"
    set-status "${status_file}" "${repo_id}" "${tool}" "error"
    echo "An error occured when running ${tool} for ${repo_id}" > "${output_file}"
    echo "----------------" >> "${output_file}"
    cat "${output_dir}/out.txt" >> "${output_file}"

}

# $1 - Repository ID
# $2 - Tool name
# $3 - Output dir
# $4 - Status file
function handle-timeout() {
    local repo_id=$1
    local tool=$2
    local output_dir=$3
    local status_file=$4
    local output_file="${output_dir}/index.html"
    set-status "${status_file}" "${repo_id}" "${tool}" "timeout"
    echo "The invokation of ${tool} for ${repo_id} timed out after ${TIMEOUT}." > "${output_file}"
    echo "----------------" >> "${output_file}"
    cat "${output_dir}/out.txt" >> "${output_file}"
}

# $1 - Repository ID
# $2 - Tool name
# $3 - Repository path
# $4 - Output dir
# $5 - Status file
function run-tool() {
    local repo_id=$1
    local tool=$2
    local repo_path=$3
    local output_dir=$4
    local status_file=$5
    local status=running
    rm -rf "${output_dir}"
    mkdir -p "${output_dir}"

    set-status "${status_file}" "${repo_id}" "${tool}" "${status}"
    export -f "run-${tool}"
    exit_code=0;
    echo "Running ${tool} on ${repo_id}"
    timeout "${TIMEOUT}" bash -c "\"run-${tool}\" \"${repo_path}\" \"${output_dir}\"" || exit_code=$?
    if [ ${exit_code} -eq 0 ]; then
        status=success
    elif [ ${exit_code} -eq 124 ]; then
        status=timeout
    else
        status=error
    fi
    "handle-${status}" "${repo_id}" "${tool}" "${output_dir}" "${status_file}"
}

# $1 - Repository Name
# $2 - Repository Path
# $3 - Repository URL
function perform-update() {
    local name=$1
    local repo_path=$2
    local repo_url=$3
    local status_file="${OUTPUT_BASE_DIR}/status.json"
    local path; path=$(basename "${repo_path}")
    local repo_id=${name,,}

    echo "-- ${name} --"
    update-repository "${name}" "${repo_id}" "${repo_path}" "${repo_url}" "${status_file}"
    while IFS= read -r tool
    do
        run-tool "${repo_id}" "${tool}" "${repo_path}" "${OUTPUT_BASE_DIR}/${path}/${tool}" "${status_file}"
    done < <(get-tools)
}

function gitinfo-update() {
    for-each-repository perform-update
}

(return 0 2>/dev/null) || gitinfo-update
