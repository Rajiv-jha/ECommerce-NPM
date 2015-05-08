# This script is provided for illustration purposes only.
#
# To build the ECommerce demo application, you will need to download the following components:
# 1. An appropriate version of the Oracle Java 7 JDK
#    (http://www.oracle.com/technetwork/java/javase/downloads/index.html)
# 2. Correct versions for the AppDynamics AppServer Agent, Machine Agent and Database Monitoring Agent for your Controller installation
#    (https://download.appdynamics.com)
#
# To run the ECommerce demo application, you will also need to:
# 1. Build and run the ECommerce-Oracle docker container
#    The Dockerfile is available here (https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-Oracle) 
#    The container requires you to downlaod an appropriate version of the Oracle Database Express Edition 11g Release 2
#    (http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html)
# 2. Download and run the official Docker mysql container
#    (https://registry.hub.docker.com/_/mysql/)

#!/bin/sh

VERSION=$1
if [ -z "$1" ]; then
        export VERSION="latest";
else
        export VERSION=$1;
fi

# Default application name
APP_NAME=$2
if [ -z "$2" ]; then
        export APP_NAME="ECommerce";
else
        export APP_NAME=$2;
fi

# Controller host/port
CONTR_HOST=controller
CONTR_PORT=8090

# Analytics config parameters
ACCOUNT_NAME=
ACCESS_KEY=
EVENT_ENDPOINT=

# Load gen parameters
NUM_OF_USERS=1
TIME_BETWEEN_RUNS=60000

docker run --name oracle-db -d -p 1521:1521 appdynamics/ecommerce-oracle
docker run --name db -e MYSQL_ROOT_PASSWORD=singcontroller -p 3306:3306 -d mysql
docker run --name jms -d appdynamics/ecommerce-activemq:$VERSION
sleep 30

docker run --name ws -h ${APP_NAME}-ws -e create_schema=true -e ws=true -e EVENT_ENDPOINT=${EVENT_ENDPOINT} -e NODE_NAME=${APP_NAME}_WS_NODE -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e APP_NAME=$APP_NAME --link db:db --link jms:jms --link oracle-db:oracle-db --link controller:controller -d appdynamics/ecommerce-tomcat:$VERSION
docker run --name web -h ${APP_NAME}-web -e EVENT_ENDPOINT=${EVENT_ENDPOINT} -e NODE_NAME=${APP_NAME}_WEB1_NODE -e JVM_ROUTE=route1 -e web=true -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e APP_NAME=$APP_NAME --link db:db --link ws:ws --link jms:jms --link controller:controller -d appdynamics/ecommerce-tomcat:$VERSION
sleep 30

docker run --name fulfillment-client -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e NODE_NAME=FulfillmentClient1 -e APP_NAME=Fulfillment -e TIER_NAME=Fulfillment-Client --link controller:controller -d appdynamics/ecommerce-fullfilment-client:$VERSION
sleep 30

docker run --name web1 -h ${APP_NAME}-web1 -e web=true -e EVENT_ENDPOINT=${EVENT_ENDPOINT} -e NODE_NAME=${APP_NAME}_WEB2_NODE -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e JVM_ROUTE=route2 -e APP_NAME=$APP_NAME --link db:db --link ws:ws --link jms:jms --link controller:controller -d appdynamics/ecommerce-tomcat:$VERSION
sleep 30

docker run --name=lbr --link web:web --link web1:web1 -p 80:80 -d appdynamics/ecommerce-lbr:$VERSION
docker run --name msg -h ${APP_NAME}-msg -e jms=true -e EVENT_ENDPOINT=${EVENT_ENDPOINT} -e NODE_NAME=${APP_NAME}_JMS_NODE -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e APP_NAME=$APP_NAME --link db:db --link jms:jms --link oracle-db:oracle-db --link fulfillment:fulfillment --link controller:controller -d appdynamics/ecommerce-tomcat:$VERSION
sleep 30

docker run --name=load-gen --link lbr:lbr -d appdynamics/ecommerce-load:$VERSION
docker run --name dbagent -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} --link db:db --link oracle-db:oracle-db --link controller:controller -d appdynamics/ecommerce-dbagent:$VERSION
