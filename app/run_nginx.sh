#!/usr/bin/env bash

/usr/share/gitinfo/gitinfo-init.sh \
    || echo "gitinfo-init.sh failed. Could be missing credentials or otherwise unable to access gitlab."

envsubst < /etc/nginx/conf.d/gitinfo.conf.template > /etc/nginx/conf.d/gitinfo.conf
nginx -g "daemon off;"
