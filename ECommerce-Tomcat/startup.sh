#!/bin/bash
CWD=${PWD}
cd /ECommerce-Java;gradle createDB

if [ -z "${CONTROLLER}" ]; then
	export CONTROLLER="controller";
fi


if [ -z "${APP_NAME}" ]; then
	export APP_NAME="ECommerce-Demo";
fi

	if [ -n "${web}" ]; then
		if [ -z "${NODE_NAME}" ]; then
			export NODE_NAME="Node_8000";
		fi
		
		if [ -z "${TIER_NAME}" ]; then
			export TIER_NAME="ECommerce-Server";
		fi
		
        cp  /ECommerce-Java/ECommerce-Web/build/libs/appdynamicspilot.war /tomcat/webapps;
        
fi

if [ -n "${jms}" ]; then
		if [ -z "${NODE_NAME}" ]; then
			export NODE_NAME="Node_8003";
		fi
		
		if [ -z "${TIER_NAME}" ]; then
			export TIER_NAME="Order-Processing-Server";
		fi
 	cp /ECommerce-Java/ECommerce-JMS/build/libs/appdynamicspilotjms.war /tomcat/webapps;
fi

if [ -n "${ws}" ]; then
		if [ -z "${NODE_NAME}" ]; then
			export NODE_NAME="Node_8002";
		fi
		
		if [ -z "${TIER_NAME}" ]; then
			export TIER_NAME="Inventory-Server";
		fi
        cp /ECommerce-Java/ECommerce-WS/build/libs/cart.war /tomcat/webapps;
fi

JAVA_OPTS="-Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=80 -Dappdynamics.agent.applicationName=${APP_NAME} -Dappdynamics.agent.tierName=${TIER_NAME} -Dappdynamics.agent.nodeName=${NODE_NAME}"

JAVA_OPTS="${JAVA_OPTS} -Xmx512m -XX:MaxPermSize=128m -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Dappdynamics.agent.uniqueHostId=cart-machine";

echo $JAVA_OPTS;

cd ${CATALINA_HOME}/bin;

apachectl start;
java -javaagent:${CATALINA_HOME}/appagent/javaagent.jar ${JAVA_OPTS} -cp ${CATALINA_HOME}/bin/bootstrap.jar:${CATALINA_HOME}/bin/tomcat-juli.jar org.apache.catalina.startup.Bootstrap

cd ${CWD}