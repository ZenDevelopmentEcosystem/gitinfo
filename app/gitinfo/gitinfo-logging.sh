#!/usr/bin/env bash

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
