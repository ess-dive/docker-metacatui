#!/usr/bin/env bash

set -e

if [ -z $1 ] ;
  then
    echo "Usage: $0 <metacatui_tag> (<uid> <gid>)"
    exit
fi

BUILD_ARGS=""
if [ ! -z $2 ] ;
then
    ESSDIVE_UID=$2
fi

if [ ! -z $3 ] ;
then
    ESSDIVE_GID=$3
fi

if [ ! -z $METACAT_UID ];
then
  BUILD_ARGS="${BUILD_ARGS} --build-arg METACATUI_UID=$ESSDIVE_UID"
fi

if [ ! -z $METACAT_GID ];
then
  BUILD_ARGS="${BUILD_ARGS} --build-arg METACATUI_GID=$ESSDIVE_GID"
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

