#!/usr/bin/env bash

set -e

if [ "$1" = 'httpd' ]; then

    # If there is a context set create the directory
    mkdir -p /usr/local/apache2/htdocs/$METACATUI_CONTEXT


    # Is there a certificate chain to add?
    if [ -f $CA_BUNDLE_CERT ];
    then
        echo "Appending certificate chain from $CA_BUNDLE_CERT "
        cat $CA_BUNDLE_CERT >> /usr/local/apache2/conf/ssl.crt/ca-bundle.crt
    fi


    # Now copy the metacatui files over
    cp -rn /tmp/metacatui/* /usr/local/apache2/htdocs/$METACATUI_CONTEXT

    if [ "$ENABLE_SSL" == "1" ];
    then
        EXTRA_ARGS="-D EnableSSL"
    fi


fi

exec $@ $EXTRA_ARGS