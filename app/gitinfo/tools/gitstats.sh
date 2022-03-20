#!/usr/bin/env bash

# $1 - Repository path
# $2 - Output dir
function run-gitstats() {
    local repo_path=$1
    local output_dir=$2

    { /usr/local/bin/gitstats "${repo_path}" "${output_dir}"; } > "${output_dir}/out.txt" 2>&1
}
