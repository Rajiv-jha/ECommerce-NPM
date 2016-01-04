#!/bin/bash

if [ -z "${CONTROLLER}" ]; then
	export CONTROLLER="controller";
fi

if [ -z "${APPD_PORT}" ]; then
	export APPD_PORT=8090;
fi

if [ -z "${APP_NAME}" ]; then
	export APP_NAME="ECommerce-Demo";
fi

if [ -z "${TIER_NAME}" ]; then
	export TIER_NAME="ECommerce-WebTier";
fi

if [ -z "${NODE_NAME}" ]; then
	export NODE_NAME="ECommerce-Apache";
fi

if [ -z "${MACHINE_PATH_1}" ]; then
        export MACHINE_PATH_1="ECommerce";
fi

if [ -z "${MACHINE_PATH_2}" ]; then
        export MACHINE_PATH_2="WebTier-Apache";
fi

export HTTPD_24=/opt/rh/httpd24/root/etc/httpd
export NATIVE_SDK_HOME=/opt/appdynamics-sdk-native

export JAVA_OPTS="-Xmx512m -XX:MaxPermSize=256m"

# Uncomment these lines to use system proeprties to override controller-info.xml settings
export APPD_CONTROLLER_OPTS="-Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT}"
export APPD_APPLICATION_OPTS="-Dappdynamics.agent.applicationName=${APP_NAME} -Dappdynamics.agent.tierName=${TIER_NAME} -Dappdynamics.agent.nodeName=${NODE_NAME}"
export APPD_ACCOUNT_OPTS="-Dappdynamics.agent.accountName=${ACCOUNT_NAME%%_*} -Dappdynamics.agent.accountAccessKey=${ACCESS_KEY}"
export APPD_HOSTID_OPTS="-DuniqueHostId=${HOSTNAME}"
export APPD_SIM_OPTS="-Dappdynamics.sim.enabled=true"

export MACHINE_AGENT_JAVA_OPTS="${JAVA_OPTS} ${APPD_CONTROLLER_OPTS} ${APPD_ACCOUNT_OPTS} ${APPD_HOSTID_OPTS} ${APPD_SIM_OPTS}"
