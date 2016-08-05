#!/bin/sh

source /env.sh

k=$(find /tomcat/appagent/ -maxdepth 1 -type d -name "ver*" | sed "s:^/tomcat/appagent/::")
sed -i "s/127.0.0.1/${IP_ADDRESS}/g" /tomcat/appagent/$k/external-services/npm/npm-service.properties
sed -i "s/localhost/${IP_ADDRESS}/g" /tomcat/appagent/$k/external-services/npm/npm-service.properties

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

# This script should not return or the container will exit
# The last command called should execute in the foreground

# Start Machine Agent
# Start manually with: docker exec <container> /start-machine-agent.sh
# /start-machine-agent.sh

# Start App Server Agent
/start-appserver-agent.sh
