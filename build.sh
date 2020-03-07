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

if [ ! -z $ESSDIVE_UID ];
then
  BUILD_ARGS="${BUILD_ARGS} --build-arg METACATUI_UID=$ESSDIVE_UID"
fi

if [ ! -z $ESSDIVE_GID ];
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

echo "************************************"
echo " Checking for a new httpd:2.4 image "
echo "************************************"

# Get the current image id
if [ ! -z "`docker image ls httpd:2.4 | grep httpd`" ];
then
    ID_IMAGE_LOCAL=`docker inspect --format='{{.Id}}' httpd:2.4`
fi

docker pull httpd:2.4

# Get the new image id
ID_IMAGE_REMOTE=`docker inspect --format='{{.Id}}' httpd:2.4`

echo "ID_IMAGE_LOCAL  $ID_IMAGE_LOCAL"
echo "ID_IMAGE_REMOTE $ID_IMAGE_REMOTE"

if [ ! -z $ID_IMAGE_LOCAL ] && [ "$ID_IMAGE_REMOTE" != "$ID_IMAGE_LOCAL" ];
then
    echo "***********************************"
    echo "A new httpd:2.4 image was pulled"
    echo "***********************************"
    docker run --entrypoint "/bin/cat" httpd:2.4  conf/httpd.conf > image-httpd.conf
    docker run --entrypoint "/bin/cat" httpd:2.4  conf/extra/httpd-ssl.conf > image-httpd-ssl.conf

    DIFF_CONFS=`git diff image-httpd.conf image-httpd-ssl.conf`
    if [ ! -z $DIFF_CONFS ];
    then
        echo "***************************************"
        echo "One of the image configs is different"
        echo "You need to review for patch changes"
        echo "***************************************"
        echo $DIFF_CONFS
        exit 1
    fi

fi

echo "***********************************"
echo "Patching configuration files"
echo "***********************************"

# Create path files for the apache conf files
diff  -u image-httpd.conf httpd.conf > httpd.conf.patch || true
diff  -u image-httpd-ssl.conf httpd-ssl.conf > httpd-ssl.conf.patch || true

cd $DIR
DOCKER_TAG="${METACATUI_TAG}-p$(cd $DIR; git rev-list HEAD --count)"
# CREATE image_version.yml
echo "****************************"
echo "BUILDING image_version"
echo "****************************"
git log -n 1 --pretty="commit_count:  $(git rev-list HEAD --count)%ncommit_hash:   %h%nsubject:       %s%ncommitter:     %cN <%ce>%ncommiter_date: %ci%nauthor:        %aN <%ae>%nauthor_date:   %ai%nref_names:     %D" > image_version.yml
cat image_version.yml


# Determine if there is an image
IMAGE_NAME="metacatui:${DOCKER_TAG}"
if [ "${REGISTRY_SPIN}" != "" ];
then
  # There is a spin registry
  IMAGE_NAME="${REGISTRY_SPIN}/${IMAGE_NAME}"
fi

echo "docker build ${DOCKER_BUILD_OPTIONS} -t ${IMAGE_NAME} $BUILD_ARGS ."
docker build ${DOCKER_BUILD_OPTIONS}  -t ${IMAGE_NAME} $BUILD_ARGS .

