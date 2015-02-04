#!/bin/sh

APP_NAME=$1
CONTR_HOST=controller
CONTR_PORT=8090
if [ -z "$1" ]; then
        export APP_NAME="ECommerce";
else
        export APP_NAME=$1;
fi

docker run --name oracle-db -d -p 1521:1521 appdynamics/ecommerce-oracle
docker run --name db -e MYSQL_ROOT_PASSWORD=singcontroller -p 3306:3306 -d mysql
docker run --name jms -d appdynamics/ecommerce-activemq
sleep 30

docker run --name ws -e create_schema=true -e ws=true -e NODE_NAME=${APP_NAME}_WS_NODE -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e APP_NAME=$APP_NAME --link db:db --link jms:jms --link oracle-db:oracle-db --link controller:controller -d appdynamics/ecommerce-tomcat
docker run --name web -e NODE_NAME=${APP_NAME}_WEB1_NODE -e JVM_ROUTE=route1 -e web=true -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e APP_NAME=$APP_NAME --link db:db --link ws:ws --link jms:jms --link controller:controller -d appdynamics/ecommerce-tomcat
sleep 30

docker run --name fulfillment -e web=true -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e NODE_NAME=Fulfillment -e APP_NAME=Fulfillment -e TIER_NAME=Fulfillment-Processor --link db:db --link ws:ws --link jms:jms --link oracle-db:oracle-db --link controller:controller -d appdynamics/ecommerce-tomcat
sleep 30

docker run --name web1 -e web=true -e NODE_NAME=${APP_NAME}_WEB2_NODE -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e JVM_ROUTE=route2 -e APP_NAME=$APP_NAME --link db:db --link ws:ws --link jms:jms --link controller:controller -d appdynamics/ecommerce-tomcat
sleep 30

docker run --name=lbr --link web:web --link web1:web1 -p 80:80 -d appdynamics/ecommerce-lbr
docker run --name msg -e jms=true -e NODE_NAME=${APP_NAME}_JMS_NODE -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e APP_NAME=$APP_NAME --link db:db --link jms:jms --link oracle-db:oracle-db --link fulfillment:fulfillment --link controller:controller -d appdynamics/ecommerce-tomcat
sleep 30

docker run --name=load-gen --link lbr:lbr -d appdynamics/ecommerce-load
docker run --name dbagent -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} --link db:db --link oracle-db:oracle-db --link controller:controller -d appdynamics/ecommerce-dbagent
