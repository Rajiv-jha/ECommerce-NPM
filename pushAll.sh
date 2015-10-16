#! /bin/bash

if [ "$#" -ne 3 ]; then
  read -e -p "Application: " APP_NAME;
  read -e -p "Version: " TAG_VERSION;
  read -e -p "Registry: " REGISTRY;
else
  export APP_NAME=$1;
  export TAG_VERSION=$2;
  export REGISTRY=$3;
fi

for i in $(docker images | grep ${REGISTRY} | grep ${APP_NAME} | grep $TAG_VERSION | awk {'print $1'}); do
    echo Pushing:  $i:${TAG_VERSION}
    docker push $i:$TAG_VERSION
done
