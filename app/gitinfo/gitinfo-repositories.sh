#!/usr/bin/env bash

(return 0 2>/dev/null) || set -eu

GITLAB_REPOSITORIES_JSON=

function get-repositories-names() {
    [ -z "${GITLAB_REPOSITORIES_JSON}" ] && populate-repo-json
    echo "${GITLAB_REPOSITORIES_JSON}" | jq -r '.[]|select(.namespace.name=="repos")|.name'
}

function get-repositories-urls() {
    [ -z "${GITLAB_REPOSITORIES_JSON}" ] && populate-repo-json
    echo "${GITLAB_REPOSITORIES_JSON}" | jq -r '.[]|select(.namespace.name=="repos")|.http_url_to_repo'
}

function get-repositories-paths() {
    [ -z "${GITLAB_REPOSITORIES_JSON}" ] && populate-repo-json
    echo "${GITLAB_REPOSITORIES_JSON}" | jq -r '.[]|select(.namespace.name=="repos")|.path'
}

function populate-repo-json() {
    GITLAB_REPOSITORIES_JSON=$(curl \
        --silent --show-error \
        --header "Authorization: Bearer ${GITINFO_GITLAB_TOKEN}" \
        "${GITINFO_GITLAB_URL}/api/v4/projects?per_page=1000")
    export GITLAB_REPOSITORIES_JSON
}

# $1 function to call, func(name, repo_path, repo_url)
function for-each-repository() {
    local func=$1; shift
    declare -a args=( "${@}" )

    local name
    local repo_path
    local repo_url

    declare -a names; mapfile -t names < <(get-repositories-names)
    declare -a paths; mapfile -t paths < <(get-repositories-paths)
    declare -a urls; mapfile -t urls < <(get-repositories-urls)

    for index in "${!names[@]}"; do
        name="${names[${index}]}"
        repo_path="${REPO_BASE_DIR}/${paths[${index}]}"
        repo_url="${urls[${index}]}"

        "${func}" "${name}" "${repo_path}" "${repo_url}" "${args[@]}"
    done

}
