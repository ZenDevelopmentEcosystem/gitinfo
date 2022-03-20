#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Paranoia that ensures we don't get stuff like “’ instead of "'
export LC_ALL=C
export LANG=C

main() {
    docker exec gitinfo /usr/share/gitinfo/gitinfo-update.sh
}

main
