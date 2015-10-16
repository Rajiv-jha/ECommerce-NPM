#! /bin/bash

if [ "$#" -ne 2 ]; then
  read -e -p "Version: " TAG_VERSION;
  read -e -p "Registry: " REGISTRY;
else
  export TAG_VERSION=$1;
  export REGISTRY="$2";
fi

docker rmi ${REGISTRY}/ecommerce/ecommerce-tomcat:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce/ecommerce-lbr:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce/ecommerce-dbagent:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce/ecommerce-synapse:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce/ecommerce-fulfillment-client:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce/ecommerce-angular:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce/ecommerce-faultinjection:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce/ecommerce-load:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce/ecommerce-survey-client:$TAG_VERSION
docker rmi ${REGISTRY}/ecommerce/ecommerce-dbwrapper:$TAG_VERSION

if [[ `docker images -q --filter "dangling=true"` ]]
then
  echo
  echo "Deleting intermediate containers..."
  docker images -q --filter "dangling=true" | xargs docker rmi;
fi
