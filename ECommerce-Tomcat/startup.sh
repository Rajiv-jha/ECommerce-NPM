#!/bin/sh
CWD=${PWD}

source /env.sh

if [ "${create_schema}" == "true" ]; then
	cd /ECommerce-Java;gradle createDB
fi

if [ -n "${web}" ]; then
        cp  /ECommerce-Java/ECommerce-Web/build/libs/appdynamicspilot.war /tomcat/webapps;
fi

if [ -n "${jms}" ]; then
 	cp /ECommerce-Java/ECommerce-JMS/build/libs/appdynamicspilotjms.war /tomcat/webapps;
fi

if [ -n "${ws}" ]; then
        cp /ECommerce-Java/ECommerce-WS/build/libs/cart.war /tomcat/webapps;
fi

source /start-machine-agent.sh
source /start-appserver-agent.sh

cd ${CWD}
