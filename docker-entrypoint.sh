#!/usr/bin/env bash

set -e

if [ "$1" = 'httpd' ]; then

    # If there is a context set create the directory
    mkdir -p /usr/local/apache2/htdocs/$METACATUI_CONTEXT


    # Now copy the metacatui files over
    cp -rn /tmp/metacatui/* /usr/local/apache2/htdocs/$METACATUI_CONTEXT

    if [ "$ENABLE_SSL" == "1" ];
    then
        EXTRA_ARGS="-D EnableSSL"
    fi


fi

exec $@ $EXTRA_ARGS