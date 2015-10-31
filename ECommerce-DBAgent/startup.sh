#!/bin/bash
CWD=${PWD}

source env.sh

if [ -z "${CONTROLLER}" ]; then
	export CONTROLLER="controller";
fi

if [ -z "${APPD_PORT}" ]; then
	export APPD_PORT=8090;
fi

CONTROLLER_INFO_SETTINGS="s/CONTROLLERHOST/${CONTROLLER}/g;
s/CONTROLLERPORT/${APPD_PORT}/g;
s/ACCOUNTNAME/${ACCOUNT_NAME%%_*}/g;
s/ACCOUNTACCESSKEY/${ACCESS_KEY}/g"

sed -e "${CONTROLLER_INFO_SETTINGS}" /controller-info.xml > /${AGENT_HOME}/conf/controller-info.xml

JAVA_OPTS="-Duser.timezone=UTC -Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT} -Dappdynamics.agent.accountName=${ACCOUNT_NAME%%_*} -Dappdynamics.agent.accountAccessKey=${ACCESS_KEY}";
JAVA_OPTS="${JAVA_OPTS} -Xmx512m -XX:MaxPermSize=128m -Duser.timezone=UTC";
echo $JAVA_OPTS;

cd ${CATALINA_HOME}/bin;
java ${JAVA_OPTS} -Ddbagent.name=$(hostname) -jar ${AGENT_HOME}/db-agent.jar 
cd ${CWD}
