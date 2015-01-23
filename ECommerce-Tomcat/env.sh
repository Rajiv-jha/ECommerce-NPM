#!/bin/bash

if [ -n "${create_schema}" ]; then
	export CREATE_SCHEMA=false;
fi

if [ -z "${APP_NAME}" ]; then
	export APP_NAME="ECommerce-Demo";
fi

if [ -z "${CONTROLLER}" ]; then
	export CONTROLLER="controller";
fi

if [ -z "${APPD_PORT}" ]; then
	export APPD_PORT=8090;
fi

if [ -z "JVM_ROUTE" ]; then
	export JVM_ROUTE="route1";
fi


if [ -z "${APP_NAME}" ]; then
	export APP_NAME="ECommerce-Demo";
fi

if [ -z "${EUM_CLOUD}" ]; then
	export EUM_CLOUD="eumcloud.demo.appdynamics.com";
fi

if [ -z "${ACCOUNT_NAME}" ]; then
	export ACCOUNT_NAME="customer1";
fi

if [ -n "${web}" ]; then
		if [ -z "${NODE_NAME}" ]; then
			export NODE_NAME="Node_8000";
		fi
		
		if [ -z "${TIER_NAME}" ]; then
			export TIER_NAME="ECommerce-Server";
		fi                
fi

if [ -n "${jms}" ]; then
		if [ -z "${NODE_NAME}" ]; then
			export NODE_NAME="Node_8003";
		fi
		
		if [ -z "${TIER_NAME}" ]; then
			export TIER_NAME="Order-Processing-Server";
		fi
 	
fi

if [ -n "${ws}" ]; then
		if [ -z "${NODE_NAME}" ]; then
			export NODE_NAME="Node_8002";
		fi
		
		if [ -z "${TIER_NAME}" ]; then
			export TIER_NAME="Inventory-Server";
		fi
fi
export AGENT_OPTS="-Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT} -Dappdynamics.agent.applicationName=${APP_NAME} -Dappdynamics.agent.tierName=${TIER_NAME} -Dappdynamics.agent.nodeName=${NODE_NAME}";
export JAVA_OPTS="${AGENT_OPTS} -DjvmRoute=${JVM_ROUTE} -Xmx512m -XX:MaxPermSize=128m -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager";
