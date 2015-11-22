#! /bin/bash

if [ "$#" -eq 1 ]; then
  export TAG_VERSION=$1
  export REGISTRY="appdynamics"
elif [ "$#" -eq 2 ]; then
  export TAG_VERSION=$1;
  export REGISTRY=$2;
else
  echo "Usage: tagAll.sh <tag> [<registry>]"
  exit
fi

docker rmi ${REGISTRY}/ecommerce-tomcat:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce-lbr:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce-dbagent:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce-synapse:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce-fulfillment-client:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce-angular:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce-faultinjection:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce-load:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce-survey-client:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce-dbwrapper:$TAG_VERSION

if [[ `docker images -q --filter "dangling=true"` ]]
then
  echo
  echo "Deleting intermediate containers..."
  docker images -q --filter "dangling=true" | xargs docker rmi;
fi
