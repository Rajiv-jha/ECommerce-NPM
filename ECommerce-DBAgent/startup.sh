#!/bin/bash
CWD=${PWD}

if [ -z "${CONTROLLER}" ]; then
	export CONTROLLER="controller";
fi

if [ -z "${APPD_PORT}" ]; then
	export APPD_PORT=8090;
fi

JAVA_OPTS="-Duser.timezone=UTC -Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT}";

JAVA_OPTS="${JAVA_OPTS} -Xmx512m -XX:MaxPermSize=128m -Duser.timezone=UTC";

echo $JAVA_OPTS;

cd ${CATALINA_HOME}/bin;

java ${JAVA_OPTS} -jar ${AGENT_HOME}/db-agent.jar 

cd ${CWD}
