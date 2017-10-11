#!/usr/bin/env bash

set -e

if [ "$1" = 'httpd' ]; then
    if [ $ENABLE_SSL -eq 1 ];
    then
        $@ -D EnableSSL
    fi

fi

exec $@