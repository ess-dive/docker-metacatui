#!/usr/bin/env bash

set -e

if [ "$1" = 'httpd' ]; then
    if [ $ENABLE_SSL -eq 1 ];
    then
        EXTRA_ARGS="-D EnableSSL"
    fi


fi

exec $@ $EXTRA_ARGS