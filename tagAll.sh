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

export TOMCAT_LATEST=`docker images | grep 'appdynamics/ecommerce-tomcat' | grep 'latest' | awk '{print $3}'`
export LBR_LATEST=`docker images | grep 'appdynamics/ecommerce-lbr' | grep 'latest' | awk '{print $3}'`
export DBAGENT_LATEST=`docker images | grep 'appdynamics/ecommerce-dbagent' | grep 'latest' | awk '{print $3}'`
export SYNAPSE_LATEST=`docker images | grep 'appdynamics/ecommerce-synapse' | grep 'latest' | awk '{print $3}'`
export FULFILLMENT_CLIENT_LATEST=`docker images | grep 'appdynamics/ecommerce-fulfillment-client' | grep 'latest' | awk '{print $3}'`
export ANGULAR_LATEST=`docker images | grep 'appdynamics/ecommerce-angular' | grep 'latest' | awk '{print $3}'`
export FAULTINJECTION_LATEST=`docker images | grep 'appdynamics/ecommerce-faultinjection' | grep 'latest' | awk '{print $3}'`
export LOAD_LATEST=`docker images | grep 'appdynamics/ecommerce-load' | grep 'latest' | awk '{print $3}'`
export SURVEY_LATEST=`docker images | grep 'appdynamics/ecommerce-survey-client' | grep 'latest' | awk '{print $3}'`
export DBWRAPPER_LATEST=`docker images | grep 'appdynamics/ecommerce-dbwrapper' | grep 'latest' | awk '{print $3}'`

if [ ${REGISTRY} == "appdynamics" ]; then
  echo "Tagging to Registry: Dockerhub"
else
  echo "Tagging to Registry: ${REGISTRY}"
fi

docker tag -f $TOMCAT_LATEST ${REGISTRY}/ecommerce-tomcat:$TAG_VERSION
docker tag -f $LBR_LATEST ${REGISTRY}/ecommerce-lbr:$TAG_VERSION
docker tag -f $DBAGENT_LATEST ${REGISTRY}/ecommerce-dbagent:$TAG_VERSION
docker tag -f $SYNAPSE_LATEST ${REGISTRY}/ecommerce-synapse:$TAG_VERSION
docker tag -f $FULFILLMENT_CLIENT_LATEST ${REGISTRY}/ecommerce-fulfillment-client:$TAG_VERSION
docker tag -f $ANGULAR_LATEST ${REGISTRY}/ecommerce-angular:$TAG_VERSION
docker tag -f $FAULTINJECTION_LATEST ${REGISTRY}/ecommerce-faultinjection:$TAG_VERSION
docker tag -f $LOAD_LATEST ${REGISTRY}/ecommerce-load:$TAG_VERSION
docker tag -f $SURVEY_LATEST ${REGISTRY}/ecommerce-survey-client:$TAG_VERSION
docker tag -f $DBWRAPPER_LATEST ${REGISTRY}/ecommerce-dbwrapper:$TAG_VERSION

if [[ `docker images -q --filter "dangling=true"` ]]
then
  echo
  echo "Deleting intermediate containers..."
  docker images -q --filter "dangling=true" | xargs docker rmi;
fi
