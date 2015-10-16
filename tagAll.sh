#! /bin/bash

if [ "$#" -ne 2 ]; then
  read -e -p "Version: " TAG_VERSION;
  read -e -p "Registry: " REGISTRY;
else
  export TAG_VERSION=$1;
  export REGISTRY=$2;
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

docker tag -f $TOMCAT_LATEST ${REGISTRY}/ecommerce/ecommerce-tomcat:$TAG_VERSION
docker tag -f $LBR_LATEST ${REGISTRY}/ecommerce/ecommerce-lbr:$TAG_VERSION
docker tag -f $DBAGENT_LATEST ${REGISTRY}/ecommerce/ecommerce-dbagent:$TAG_VERSION
docker tag -f $SYNAPSE_LATEST ${REGISTRY}/ecommerce/ecommerce-synapse:$TAG_VERSION
docker tag -f $FULFILLMENT_CLIENT_LATEST ${REGISTRY}/ecommerce/ecommerce-fulfillment-client:$TAG_VERSION
docker tag -f $ANGULAR_LATEST ${REGISTRY}/ecommerce/ecommerce-angular:$TAG_VERSION
docker tag -f $FAULTINJECTION_LATEST ${REGISTRY}/ecommerce/ecommerce-faultinjection:$TAG_VERSION
docker tag -f $LOAD_LATEST ${REGISTRY}/ecommerce/ecommerce-load:$TAG_VERSION
docker tag -f $SURVEY_LATEST ${REGISTRY}/ecommerce/ecommerce-survey-client:$TAG_VERSION
docker tag -f $DBWRAPPER_LATEST ${REGISTRY}/ecommerce/ecommerce-dbwrapper:$TAG_VERSION

if [[ `docker images -q --filter "dangling=true"` ]]
then
  echo
  echo "Deleting intermediate containers..."
  docker images -q --filter "dangling=true" | xargs docker rmi;
fi
