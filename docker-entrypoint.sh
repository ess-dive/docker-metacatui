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

    if [ "$ENABLE_REAL_IP" == "1" ];
    then
         # HTTPS termination confir (real ip)
         #
         # When using ssl termination, we need to inject proxy headers, and
         # then configure Apache with the IP address range of the proxy to
         # trust
         EXTRA_ARGS="$EXTRA_ARGS -D EnableRealIp"
    fi

fi

exec $@ $EXTRA_ARGS
