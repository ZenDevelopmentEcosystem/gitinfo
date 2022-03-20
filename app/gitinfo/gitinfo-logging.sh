#!/usr/bin/env bash

(return 0 2>/dev/null) || set -eu

function log-date() {
    date --rfc-3339=seconds
}

# $@ - message
function log-error() {
    >&2 echo "$(log-date) ERROR: $*"
}

function log-info() {
    echo "$(log-date) INFO: $*"
}
