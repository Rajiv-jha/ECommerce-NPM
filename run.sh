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

# Docker container version
if [ -z "$1" ]; then
        export VERSION="latest";
else
        export VERSION=$1;
fi
echo "Using version: $VERSION"

# Default application name
if [ -z "$2" ]; then
        export APP_NAME="ECommerce";
else
        export APP_NAME=$2;
fi
echo "Application Name: $APP_NAME"

# Controller host/port
CONTR_HOST=
CONTR_PORT=

# Analytics config parameters
ACCOUNT_NAME=
ACCESS_KEY=
EVENT_ENDPOINT=

# SIM Hierarchy parameters
SIM_HIERARCHY_1=
SIM_HIERARCHY_2=
# Uncomment to use AWS metadata
#SIM_HIERACRHY_1=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
#SIM_HIERARCHY_2=$(curl -s http://169.254.169.254//latest/meta-data/public-hostname)

# AWS Credentials for Fulfillment-Client
AWS_ACCESS_KEY=
AWS_SECRET_KEY=

# Load gen parameters
NUM_OF_USERS=1
TIME_BETWEEN_RUNS=60000

docker run --name oracle-db -d -p 1521:1521 appdynamics/ecommerce-oracle
docker run --name db -e MYSQL_ROOT_PASSWORD=singcontroller -p 3306:3306 -d mysql
docker run --name jms -d appdynamics/ecommerce-activemq:
sleep 30

docker run --name ws -h ${APP_NAME}-ws -e create_schema=true -e ws=true -e EVENT_ENDPOINT=${EVENT_ENDPOINT} -e NODE_NAME=${APP_NAME}_WS_NODE -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e APP_NAME=$APP_NAME -e SIM_HIERARCHY_1=${SIM_HIERARCHY_1} -e SIM_HIERARCHY_2=${SIM_HIERARCHY_2} --link db:db --link jms:jms --link oracle-db:oracle-db -d appdynamics/ecommerce-tomcat:$VERSION
docker run --name web -h ${APP_NAME}-web -e EVENT_ENDPOINT=${EVENT_ENDPOINT} -e NODE_NAME=${APP_NAME}_WEB1_NODE -e JVM_ROUTE=route1 -e web=true -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e APP_NAME=$APP_NAME -e SIM_HIERARCHY_1=${SIM_HIERARCHY_1} -e SIM_HIERARCHY_2=${SIM_HIERARCHY_2} --link db:db --link ws:ws --link jms:jms -d appdynamics/ecommerce-tomcat:$VERSION
sleep 30

docker run --name fulfillment -h ${APP_NAME}-fulfillment -e EVENT_ENDPOINT=${EVENT_ENDPOINT} -e web=true -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e NODE_NAME=Fulfillment -e APP_NAME=${APP_NAME}-Fulfillment -e TIER_NAME=Fulfillment-Processor -e AWS_ACCESS_KEY=${AWS_ACCESS_KEY} -e AWS_SECRET_KEY=${AWS_SECRET_KEY} -e SIM_HIERARCHY_1=${SIM_HIERARCHY_1} -e SIM_HIERARCHY_2=${SIM_HIERARCHY_2} --link db:db --link ws:ws --link jms:jms --link oracle-db:oracle-db -d appdynamics/ecommerce-tomcat:$VERSION
sleep 30

docker run --name fulfillment-client -h ${APP_NAME}-fulfillment-client -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e NODE_NAME=FulfillmentClient1 -e APP_NAME=${APP_NAME}-Fulfillment -e TIER_NAME=Fulfillment-Client -e AWS_ACCESS_KEY=${AWS_ACCESS_KEY} -e AWS_SECRET_KEY=${AWS_SECRET_KEY} i-e SIM_HIERARCHY_1=${SIM_HIERARCHY_1} -e SIM_HIERARCHY_2=${SIM_HIERARCHY_2} -d appdynamics/ecommerce-fulfillment-client:$VERSION
sleep 30

docker run --name web1 -h ${APP_NAME}-web1 -e web=true -e EVENT_ENDPOINT=${EVENT_ENDPOINT} -e NODE_NAME=${APP_NAME}_WEB2_NODE -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e JVM_ROUTE=route2 -e APP_NAME=$APP_NAME -e SIM_HIERARCHY_1=${SIM_HIERARCHY_1} -e SIM_HIERARCHY_2=${SIM_HIERARCHY_2} --link db:db --link ws:ws --link jms:jms -d appdynamics/ecommerce-tomcat:$VERSION
sleep 30

docker run --name=lbr -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e APP_NAME=${APP_NAME} -e TIER_NAME=${APP_NAME}-WebServer -e NODE_NAME=${APP_NAME}-Apache -e SIM_HIERARCHY_1=${SIM_HIERARCHY_1} -e SIM_HIERARCHY_2=${SIM_HIERARCHY_2} --link web:web --link web1:web1 -p 80:80 -d appdynamics/ecommerce-lbr:$VERSION
docker run --name msg -h ${APP_NAME}-msg -e jms=true -e EVENT_ENDPOINT=${EVENT_ENDPOINT} -e NODE_NAME=${APP_NAME}_JMS_NODE -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e APP_NAME=$APP_NAME -e SIM_HIERARCHY_1=${SIM_HIERARCHY_1} -e SIM_HIERARCHY_2=${SIM_HIERARCHY_2} --link db:db --link jms:jms --link oracle-db:oracle-db --link fulfillment:fulfillment -d appdynamics/ecommerce-tomcat:$VERSION
sleep 30

docker run --name=load-gen --link lbr:lbr -d appdynamics/ecommerce-load
docker run --name dbagent -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} --link db:db --link oracle-db:oracle-db -d appdynamics/ecommerce-dbagent:$VERSION
