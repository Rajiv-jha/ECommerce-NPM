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

if [ -z "${ACCOUNT_NAME}" ]; then
	export ACCOUNT_NAME="customer1";
fi

if [ -z "${MACHINE_PATH_1}" ]; then
	export MACHINE_PATH_1="ECommerce";
fi

if [ -n "${web}" ]; then
		if [ -z "${NODE_NAME}" ]; then
			export NODE_NAME="ECommerce";
		fi
		if [ -z "${TIER_NAME}" ]; then
			export TIER_NAME="ECommerce-Services";
		fi
		if [ -z "${MACHINE_PATH_2}" ]; then
        		export MACHINE_PATH_2="ECommerce-Server";
		fi
fi

if [ -n "${jms}" ]; then
		if [ -z "${NODE_NAME}" ]; then
			export NODE_NAME="Orders";
		fi
		if [ -z "${TIER_NAME}" ]; then
			export TIER_NAME="Order-Services";
		fi
		if [ -z "${MACHINE_PATH_2}" ]; then
        		export MACHINE_PATH_2="Order-Server";
		fi
fi

if [ -n "${ws}" ]; then
		if [ -z "${NODE_NAME}" ]; then
			export NODE_NAME="Inventory";
		fi
		if [ -z "${TIER_NAME}" ]; then
			export TIER_NAME="Inventory-Services";
		fi
		if [ -z "${MACHINE_PATH_2}" ]; then
        		export MACHINE_PATH_2="Inventory-Server";
		fi
fi

# Set in Dockerfile based on installed App Server Agent version: _VERSION_STRING will be replaced during build
export VERSION_STRING="_VERSION_STRING"

export JAVA_OPTS="-Xmx512m -XX:MaxPermSize=256m"
export JMX_OPTS="-Dcom.sun.management.jmxremote.port=8888  -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

# Uncomment these lines to use system proeprties to override controller-info.xml settings
export APPD_CONTROLLER_OPTS="-Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT}"
export APPD_APPLICATION_OPTS="-Dappdynamics.agent.applicationName=${APP_NAME} -Dappdynamics.agent.tierName=${TIER_NAME} -Dappdynamics.agent.nodeName=${NODE_NAME}"
export APPD_ACCOUNT_OPTS="-Dappdynamics.agent.accountName=${ACCOUNT_NAME%%_*} -Dappdynamics.agent.accountAccessKey=${ACCESS_KEY}"
#export APPD_HOSTID_OPTS="-DuniqueHostId=${HOSTNAME}"
export APPD_SIM_OPTS="-Dappdynamics.sim.enabled=true"

export MACHINE_AGENT_JAVA_OPTS="${JAVA_OPTS} ${APPD_CONTROLLER_OPTS} ${APPD_ACCOUNT_OPTS} ${APPD_HOSTID_OPTS} ${APPD_SIM_OPTS}"
export APP_AGENT_JAVA_OPTS="${JAVA_OPTS} ${APPD_CONTROLLER_OPTS} ${APPD_ACCOUNT_OPTS} ${APPD_APPLICATION_OPTS} ${APPD_HOSTID_OPTS} -DjvmRoute=${JVM_ROUTE} -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager";
