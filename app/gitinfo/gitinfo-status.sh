#!/usr/bin/env bash

(return 0 2>/dev/null) || set -eu


# $1 - Status file
function prepare-status-file() {
    local status_file=$1
    echo '{ "tools": [], "repositories": {} }' > "${status_file}"
}

# $1 - Status file
# $2 - Repository
# $3 - Name
# $4 - URL
# $5 - Repository path
function set-base-attributes() {
    local status_file=$1
    local repo_id=$2
    local name=$3
    local repo_url=$4
    local repo_path=$5
    set-name "${status_file}" "${repo_id}" "${name}"
    set-url "${status_file}" "${repo_id}" "${repo_url}"
    set-path "${status_file}" "${repo_id}" "$(basename "${repo_path}")"
}

# $1 - Status file
# $2 - Repository
# $3 - Name
function set-name() {
    local status_file=$1
    local repo=$2
    local name=$3
    local tmp_file=${status_file}.tmp
    jq --sort-keys ".repositories.\"${repo}\".name=\"${name}\"" "${status_file}" > "${tmp_file}"
    mv "${tmp_file}" "${status_file}"
}

# $1 - Status file
# $2 - Repository
# $3 - Relative path
function set-path() {
    local status_file=$1
    local repo=$2
    local path=$3
    local tmp_file=${status_file}.tmp
    jq --sort-keys ".repositories.\"${repo}\".path=\"${path}\"" "${status_file}" > "${tmp_file}"
    mv "${tmp_file}" "${status_file}"
}

# $1 - Status file
# $2 - Repository
# $3 - Tool
# $4 - Status
function set-status() {
    local status_file=$1
    local repo=$2
    local tool=$3
    local status=$4
    local tmp_file=${status_file}.tmp
    jq --sort-keys ".repositories.\"${repo}\".tools.${tool}={ \"status\": \"${status}\", \"date\": \"$(date)\" }" "${status_file}" > "${tmp_file}"
    mv "${tmp_file}" "${status_file}"
}

# $1 - Status file
# $2 - Repository
# $3 - branch
function set-branch() {
    local status_file=$1
    local repo=$2
    local branch=$3
    local tmp_file=${status_file}.tmp
    jq --sort-keys ".repositories.\"${repo}\".branch=\"${branch}\"" "${status_file}" > "${tmp_file}"
    mv "${tmp_file}" "${status_file}"
}

# $1 - Status file
# $2 - Repository
# $3 - url
function set-url() {
    local status_file=$1
    local repo=$2
    local url=$3
    local tmp_file=${status_file}.tmp
    jq --sort-keys ".repositories.\"${repo}\".url=\"${url}\"" "${status_file}" > "${tmp_file}"
    mv "${tmp_file}" "${status_file}"
}

# $1 - Status file
# $2 - Repository
# $3 - commit
function set-commit() {
    local status_file=$1
    local repo=$2
    local commit=$3
    local tmp_file=${status_file}.tmp
    jq --sort-keys ".repositories.\"${repo}\".commit=\"${commit}\"" "${status_file}" > "${tmp_file}"
    mv "${tmp_file}" "${status_file}"
}

# $1 - Status file
# $2.. Tools array
function set-tools() {
    local status_file=$1; shift
    declare -a tools=( "$@" )
    local tmp_file=${status_file}.tmp
    jq --sort-keys --argjson args "$(printf '%s\n' "${tools[@]}"|jq -nR '[inputs]')" '.tools=$args' "${status_file}" > "${tmp_file}"
    mv "${tmp_file}" "${status_file}"
}
