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
  echo "Tagging to Default Registry: Dockerhub"
  docker tag -f $TOMCAT_LATEST appdynamics/ecommerce-tomcat:$TAG_VERSION
  docker tag -f $LBR_LATEST appdynamics/ecommerce-lbr:$TAG_VERSION
  docker tag -f $DBAGENT_LATEST appdynamics/ecommerce-dbagent:$TAG_VERSION
  docker tag -f $SYNAPSE_LATEST appdynamics/ecommerce-synapse:$TAG_VERSION
  docker tag -f $FULFILLMENT_CLIENT_LATEST appdynamics/ecommerce-fulfillment-client:$TAG_VERSION
  docker tag -f $ANGULAR_LATEST appdynamics/ecommerce-angular:$TAG_VERSION
  docker tag -f $FAULTINJECTION_LATEST appdynamics/ecommerce-faultinjection:$TAG_VERSION
  docker tag -f $LOAD_LATEST appdynamics/ecommerce-load:$TAG_VERSION
  docker tag -f $SURVEY_LATEST appdynamics/ecommerce-survey-client:$TAG_VERSION
  docker tag -f $DBWRAPPER_LATEST appdynamics/ecommerce-dbwrapper:$TAG_VERSION
else
  echo "Tagging to Registry: ${REGISTRY}"
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
fi

if [[ `docker images -q --filter "dangling=true"` ]]
then
  echo
  echo "Deleting intermediate containers..."
  docker images -q --filter "dangling=true" | xargs docker rmi;
fi
