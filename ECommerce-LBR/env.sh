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

export HTTPD_24=/opt/rh/httpd24/root/etc/httpd
export NATIVE_SDK_HOME=/opt/appdynamics-sdk-native

export AGENT_OPTS="-Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT} -Dappdynamics.agent.applicationName=${APP_NAME} -Dappdynamics.agent.tierName=${TIER_NAME} -Dappdynamics.agent.nodeName=${NODE_NAME}"
export JAVA_OPTS="-Xmx512m -XX:MaxPermSize=128m"
export MACHINE_AGENT_JAVA_OPTS="-Dappdynamics.sim.enabled=true ${JAVA_OPTS} ${AGENT_OPTS}"
