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

if [ -z "${EVENT_ENDPOINT}" ]; then
        export EVENT_ENDPOINT="eumcloud.demo.appdynamics.com:9080";
fi

if [ -z "${ACCOUNT_NAME}" ]; then
	export ACCOUNT_NAME="analytics-customer1";
fi

if [ -z "${ACCESS_KEY}" ]; then
	export ACCESS_KEY="your-account-access-key";
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

# Set in Dockerfile based on installed App Server Agent version: _VERSION_STRING will be replaced during build
export VERSION_STRING="_VERSION_STRING"

export JAVA_OPTS="-Xmx512m -XX:MaxPermSize=256m"
export APPD_JAVA_OPTS="${JAVA_OPTS} -Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT} -Dappdynamics.agent.applicationName=${APP_NAME} -Dappdynamics.agent.tierName=${TIER_NAME} -Dappdynamics.agent.nodeName=${NODE_NAME}"
export MACHINE_AGENT_JAVA_OPTS="-Dappdynamics.sim.enabled=true ${JAVA_OPTS} ${APPD_JAVA_OPTS}"
export APP_AGENT_JAVA_OPTS="${JAVA_OPTS} ${APPD_JAVA_OPTS} -Dappdynamics.agent.accountName=customer1 -Dappdynamics.agent.accountAccessKey=${ACCESS_KEY}"
export JMX_OPTS="-Dcom.sun.management.jmxremote.port=8888  -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
