#!/usr/bin/env bash

update-ca-certificates

/usr/share/gitinfo/gitinfo-init.sh \
    || echo "gitinfo-init.sh failed. Could be missing credentials or otherwise unable to access gitlab."
