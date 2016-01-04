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

# Docker Registry - default to public dockerhub account
if [ -z "${DOCKER_REGISTRY}" ]; then
    export DOCKER_REGISTRY="appdynamics"
fi

checkOptional() {
    eval VALUE=\$$1
    if [ -z "$VALUE" ]; then
        echo "$1 not set - ignoring"
    fi
}

checkRequired() {
    eval VALUE=\$$1
    if [[ -z "$VALUE" ]]; then
        echo "$1 not set - exiting"; exit
    fi
    echo "$1: $VALUE"
}

checkEnv() {
    # AWS Credentials for Fulfillment SQS Correlation
    checkOptional "AWS_ACCESS_KEY"
    checkOptional "AWS_SECRET_KEY"

    # Controller Host/Port
    checkRequired "CONTR_HOST"
    checkRequired "CONTR_PORT"

    # Analytics config parameters
    checkRequired "ACCOUNT_NAME"
    checkRequired "ACCESS_KEY"
    checkRequired "EVENT_ENDPOINT"

    # Docker Registry
    checkRequired "DOCKER_REGISTRY"
}

checkEnv

echo -n "oracle-db: "; docker run --name oracle-db -d -p 1521:1521 -p 2222:22 ${DOCKER_REGISTRY}/ecommerce-oracle
echo -n "db: "; docker run --name db -p 3306:3306 -p 2223:22 -e MYSQL_ROOT_PASSWORD=singcontroller -d ${DOCKER_REGISTRY}/ecommerce-mysql
echo -n "jms: "; docker run --name jms -d ${DOCKER_REGISTRY}/ecommerce-activemq
sleep 60

echo -n "dbwrapper: "; docker run --name rds-dbwrapper -h ${APP_NAME}-address \
	-e ACCOUNT_NAME=${ACCOUNT_NAME} -e ACCESS_KEY=${ACCESS_KEY} -e EVENT_ENDPOINT=${EVENT_ENDPOINT} \
        -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} \
        -e NODE_NAME=${APP_NAME}_ADDRESS -e APP_NAME=${APP_NAME} -e TIER_NAME=Address-Services \
        -e MACHINE_PATH_1="${APP_NAME}" -e MACHINE_PATH_2="Address-Services" \
        --link oracle-db:oracle-db -d ${DOCKER_REGISTRY}/ecommerce-dbwrapper:$VERSION

echo -n "ws: "; docker run --name ws -h ${APP_NAME}-ws -e create_schema=true -e ws=true \
        -e ACCOUNT_NAME=${ACCOUNT_NAME} -e ACCESS_KEY=${ACCESS_KEY} -e EVENT_ENDPOINT=${EVENT_ENDPOINT} \
        -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} \
        -e NODE_NAME=${APP_NAME}_INVENTORY -e APP_NAME=$APP_NAME -e TIER_NAME=Inventory-Services \
        -e MACHINE_PATH_1="${APP_NAME}" -e MACHINE_PATH_2="Inventory-Services" \
        --link jms:jms --link oracle-db:oracle-db --link rds-dbwrapper:rds-dbwrapper --link db:db \
        -d ${DOCKER_REGISTRY}/ecommerce-tomcat:$VERSION

echo -n "web: "; docker run --name web -h ${APP_NAME}-web -e JVM_ROUTE=route1 -e web=true \
        -e ACCOUNT_NAME=${ACCOUNT_NAME} -e ACCESS_KEY=${ACCESS_KEY} -e EVENT_ENDPOINT=${EVENT_ENDPOINT} \
        -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} \
        -e NODE_NAME=${APP_NAME}_WEB1 -e APP_NAME=$APP_NAME -e TIER_NAME=ECommerce-Services \
        -e MACHINE_PATH_1="${APP_NAME}" -e MACHINE_PATH_2="ECommerce-Services" \
        --link db:db --link oracle-db:oracle-db --link ws:ws --link jms:jms \
        -d ${DOCKER_REGISTRY}/ecommerce-tomcat:$VERSION
sleep 60

echo -n "fulfillment: "; docker run --name fulfillment -h ${APP_NAME}-fulfillment -e web=true \
        -e ACCOUNT_NAME=${ACCOUNT_NAME} -e ACCESS_KEY=${ACCESS_KEY} -e EVENT_ENDPOINT=${EVENT_ENDPOINT} \
        -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} \
        -e NODE_NAME=Fulfillment -e APP_NAME=${APP_NAME}-Fulfillment -e TIER_NAME=Fulfillment-Services \
        -e AWS_ACCESS_KEY=${AWS_ACCESS_KEY} -e AWS_SECRET_KEY=${AWS_SECRET_KEY} \
        -e MACHINE_PATH_1="${APP_NAME}" -e MACHINE_PATH_2="Fulfillment" \
        --link db:db --link ws:ws --link jms:jms --link oracle-db:oracle-db \
        -d ${DOCKER_REGISTRY}/ecommerce-tomcat:$VERSION
sleep 60

echo -n "fulfillment-client: "; docker run --name fulfillment-client -h ${APP_NAME}-fulfillment-client \
        -e ACCOUNT_NAME=${ACCOUNT_NAME} -e ACCESS_KEY=${ACCESS_KEY} \
        -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} \
        -e NODE_NAME=FulfillmentClient -e APP_NAME=${APP_NAME}-Fulfillment -e TIER_NAME=Fulfillment-Client-Services \
        -e AWS_ACCESS_KEY=${AWS_ACCESS_KEY} -e AWS_SECRET_KEY=${AWS_SECRET_KEY} \
        -e MACHINE_PATH_1="${APP_NAME}" -e MACHINE_PATH_2="Fulfillment-Client" \
        -d ${DOCKER_REGISTRY}/ecommerce-fulfillment-client:$VERSION

sleep 60

echo -n "web1: "; docker run --name web1 -h ${APP_NAME}-web1 -e JVM_ROUTE=route2 -e web=true \
        -e ACCOUNT_NAME=${ACCOUNT_NAME} -e ACCESS_KEY=${ACCESS_KEY} -e EVENT_ENDPOINT=${EVENT_ENDPOINT} \
        -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} \
        -e NODE_NAME=${APP_NAME}_WEB2 -e APP_NAME=$APP_NAME -e TIER_NAME=ECommerce-Services \
        -e MACHINE_PATH_1="${APP_NAME}" -e MACHINE_PATH_2="ECommerce-Services" \
        --link db:db --link oracle-db:oracle-db --link ws:ws --link jms:jms \
        -d ${DOCKER_REGISTRY}/ecommerce-tomcat:$VERSION
sleep 60

echo -n "customer-survey: "; docker run --name customer-survey -h ${APP_NAME}-customer-survey \
        -e ACCOUNT_NAME=${ACCOUNT_NAME} -e ACCESS_KEY=${ACCESS_KEY} \
        -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} \
        -e NODE_NAME=${APP_NAME}_SURVEY -e APP_NAME=${APP_NAME} -e TIER_NAME=Customer-Survey-Services \
        -e AWS_ACCESS_KEY=${AWS_ACCESS_KEY} -e AWS_SECRET_KEY=${AWS_SECRET_KEY} \
        -e MACHINE_PATH_1="${APP_NAME}" -e MACHINE_PATH_2="Customer-Survey" \
        --link jms:jms --link db:db --link oracle-db:oracle-db --link ws:ws \
        -d ${DOCKER_REGISTRY}/ecommerce-survey-client:$VERSION
sleep 60

echo -n "lbr: "; docker run --name=lbr -h ${APP_NAME}-lbr \
        -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} \
        -e APP_NAME=${APP_NAME} -e TIER_NAME=Web-Tier-Services -e NODE_NAME=${APP_NAME}_APACHE \
        -e ACCOUNT_NAME=${ACCOUNT_NAME} -e ACCESS_KEY=${ACCESS_KEY} -e EVENT_ENDPOINT=${EVENT_ENDPOINT} \
        -e MACHINE_PATH_1="${APP_NAME}" -e MACHINE_PATH_2="Web-Tier" \
        --link web:web --link web1:web1 -p 80:80 \
        -d ${DOCKER_REGISTRY}/ecommerce-lbr:$VERSION

echo -n "msg: "; docker run --name msg -h ${APP_NAME}-msg -e jms=true \
        -e ACCOUNT_NAME=${ACCOUNT_NAME} -e ACCESS_KEY=${ACCESS_KEY} -e EVENT_ENDPOINT=${EVENT_ENDPOINT} \
        -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} \
        -e NODE_NAME=${APP_NAME}_ORDER -e APP_NAME=$APP_NAME -e TIER_NAME=Order-Processing-Services \
        -e MACHINE_PATH_1="${APP_NAME}" -e MACHINE_PATH_2="Order-Processing" \
        --link db:db --link jms:jms --link oracle-db:oracle-db --link fulfillment:fulfillment \
        -d ${DOCKER_REGISTRY}/ecommerce-tomcat:$VERSION

sleep 60

echo -n "angular: "; docker run --name angular -h ${APP_NAME}-angular \
        --link lbr:lbr -p 8080:8080 \
        -d ${DOCKER_REGISTRY}/ecommerce-angular:$VERSION

echo -n "faultinjection: "; docker run --name faultinjection -h ${APP_NAME}-faultinjection \
        --link lbr:lbr -p 8088:8080 \
        -d ${DOCKER_REGISTRY}/ecommerce-faultinjection:$VERSION

# Wait for all services to be running before starting load-gen
sleep 60

echo -n "load-gen: "; docker run --name=load-gen \
        --link lbr:lbr --link angular:angular \
        -d ${DOCKER_REGISTRY}/ecommerce-load:$VERSION

echo -n "dbagent: "; docker run --name dbagent -h ${APP_NAME}-dbagent \
        -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e ACCESS_KEY=${ACCESS_KEY} \
        --link db:db --link oracle-db:oracle-db \
        -d ${DOCKER_REGISTRY}/ecommerce-dbagent:$VERSION
