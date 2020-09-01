#!/usr/bin/env bash

set -e

if [ "$1" = 'httpd' ]; then

    if [ -d /tmp/metacatui/ ];
    then
       # Now copy the metacatui files over
       echo "************************************"
       echo "Found /tmp/metacatui. Copying files"
       echo "************************************"
       cp -rfv /tmp/metacatui/* .
    fi

    if [ -f /tmp/robots.tmpl ];
    then
       # Defaults to disallow
       export ROBOT_RULE=${ROBOT_RULE:-Disallow}
       envsubst < /tmp/robots.tmpl > robots.txt
       test -f robots.txt
    fi

    if [ "$ENABLE_SSL" == "1" ];
    then
        EXTRA_ARGS="-D EnableSSL"
    fi

    if [ "$ENABLE_REVERSE_PROXY" == "1" ];
    then
         EXTRA_ARGS="$EXTRA_ARGS -D EnableReverseProxy"
    fi

fi

exec $@ $EXTRA_ARGS
