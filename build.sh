#!/usr/bin/env bash

set -e

if [ -z $1 ];
  then
    echo "Usage: $0 <metacatui_tag>"
    exit
fi


METACATUI_TAG=$1


# Get Metacat UI
if [ ! -d metacatui ];
then
    git clone https://github.com/NCEAS/metacatui.git
fi

cd metacatui
git fetch
git checkout tags/${METACATUI_TAG}
cd ..
docker build -t metacatui:${METACATUI_TAG} .
docker tag metacatui:${METACATUI_TAG} metacatui

