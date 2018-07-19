#!/usr/bin/env bash

set -e

if [ -z $1 ];
  then
    echo "Usage: $0 <metacatui_tag>"
    exit
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
METACATUI_TAG=$1


# Get Metacat UI
if [ ! -d $DIR/metacatui ];
then
    git clone https://github.com/NCEAS/metacatui.git $DIR/metacatui
fi

cd $DIR/metacatui
git fetch
git checkout tags/${METACATUI_TAG}
cd ..
docker pull httpd:2.4
docker build -t metacatui:${METACATUI_TAG} $DIR
docker tag metacatui:${METACATUI_TAG} metacatui

