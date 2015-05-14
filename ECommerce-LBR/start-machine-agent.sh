#!/bin/sh
# Read env vars for Controller, Port, App, Tier and Node names
source /opt/appdynamics-sdk-native/env.sh

echo "Starting Machine Agent..."
echo MACHINE_AGENT_JAVA_OPTS: ${MACHINE_AGENT_JAVA_OPTS}
nohup java ${MACHINE_AGENT_JAVA_OPTS} -jar ${MACHINE_AGENT_HOME}/machineagent.jar  > ${MACHINE_AGENT_HOME}/machine_agent.log 2>&1 &
