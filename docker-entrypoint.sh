#!/usr/bin/env bash

set -e

if [ "$1" = 'httpd' ]; then


    # Now copy the metacatui files over
    cp -rnv /tmp/metacatui/* .

    if [ "$ENABLE_SSL" == "1" ];
    then
        EXTRA_ARGS="-D EnableSSL"
    fi

fi

exec $@ $EXTRA_ARGS