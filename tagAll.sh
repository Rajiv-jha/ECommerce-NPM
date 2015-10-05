#! /bin/bash

if [ -z "$1" ]; then
  read -e -p "Version: " TAG_VERSION;
else
        export TAG_VERSION=$1;
fi

export TOMCAT_LATEST=`docker images | grep 'tomcat' | grep 'latest' | awk '{print $3}'`
export LBR_LATEST=`docker images | grep 'lbr' | grep 'latest' | awk '{print $3}'`
export DBAGENT_LATEST=`docker images | grep 'dbagent' | grep 'latest' | awk '{print $3}'`
export SYNAPSE_LATEST=`docker images | grep 'synapse' | grep 'latest' | awk '{print $3}'`
export FULFILLMENT_CLIENT_LATEST=`docker images | grep 'fulfillment-client' | grep 'latest' | awk '{print $3}'`
export ANGULAR_LATEST=`docker images | grep 'angular' | grep 'latest' | awk '{print $3}'`
export FAULTINJECTION_LATEST=`docker images | grep 'faultinjection' | grep 'latest' | awk '{print $3}'`
export LOAD_LATEST=`docker images | grep 'load' | grep 'latest' | awk '{print $3}'`
export SURVEY_LATEST=`docker images | grep 'survey-client' | grep 'latest' | awk '{print $3}'`
export DBWRAPPER_LATEST=`docker images | grep 'ecommerce-dbwrapper' | grep 'latest' | awk '{print $3}'`

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

if [[ `docker images -q --filter "dangling=true"` ]]
then
  echo
  echo "Deleting intermediate containers..."
  docker images -q --filter "dangling=true" | xargs docker rmi;
fi
