#!/usr/bin/env bash

# $1 - Repository path
# $2 - Output dir
function run-gitinspector() {
    local repo_path=$1
    local output_dir=$2

    PYTHONIOENCODING=utf-8 /usr/bin/gitinspector \
        --format=htmlembedded \
        --metrics \
        --responsibilities \
        --timeline \
        --file-types '**' \
        "${repo_path}"  \
        > "${output_dir}/index.html" \
        2> "${output_dir}/out.txt"
}
