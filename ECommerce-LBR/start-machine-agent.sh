#!/bin/sh
# Read env vars for Controller, Port, App, Tier and Node names
source ${NATIVE_HOME}/env.sh

echo "Configuring Machine Agent Analytics properties..."
/configAnalytics.sh

echo "Configuring Machine Agent:
  Controller: ${CONTROLLER}
  Port: ${APPD_PORT}
  App: ${APP_NAME}
  Tier: ${TIER_NAME}
  Node: ${NODE_NAME}
  SIM Hierarchy: ${SIM_HIERARCHY_1}/${SIM_HIERARCHY_2}"

CONTROLLER_INFO_SETTINGS="s/CONTROLLERHOST/${CONTROLLER}/g;
s/CONTROLLERPORT/${APPD_PORT}/g;
s/APP/${APP_NAME}/g;s/TIER/${TIER_NAME}/g;
s/NODE/${NODE_NAME}/g;
s/FOO/${SIM_HIERARCHY_1}/g;
s/BAR/${SIM_HIERARCHY_2}/g;
s/BAZ/${HOSTNAME}/g;
s/ACCOUNTNAME/${ACCOUNT_NAME%%_*}/g;
s/ACCOUNTACCESSKEY/${ACCESS_KEY}/g"

if [ -e /etc/init.d/appdynamics-machine-agent ]
then
  sed -e "${CONTROLLER_INFO_SETTINGS}" /controller-info.xml > /etc/appdynamics/machine-agent/controller-info.xml
else
  sed -e "${CONTROLLER_INFO_SETTINGS}" /controller-info.xml > ${MACHINE_AGENT_HOME}/conf/controller-info.xml
fi

echo "Starting Machine Agent..."

if [ -e /etc/init.d/appdynamics-machine-agent ]
then
  nohup service appdynamics-machine-agent start
  echo "Started Machine Agent service"
else
  echo MACHINE_AGENT_JAVA_OPTS: ${MACHINE_AGENT_JAVA_OPTS}
  echo JMX_OPTS: ${JMX_OPTS}
  nohup java ${MACHINE_AGENT_JAVA_OPTS} -jar ${MACHINE_AGENT_HOME}/machineagent.jar > ${MACHINE_AGENT_HOME}/machine-agent.out 2>&1 &
  echo "Started Machine Agent"
fi
