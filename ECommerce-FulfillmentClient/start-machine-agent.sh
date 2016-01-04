#!/bin/sh

source /env.sh

if [ -e /etc/init.d/appdynamics-machine-agent ]
then
  # Using RPM installer
  AGENT_CONFIG=/etc/appdynamics/machine-agent/controller-info.xml
else
  # Using zip installer
  AGENT_CONFIG=${MACHINE_AGENT_HOME}/conf/controller-info.xml
fi

# Uncomment to configure Agent using controller-info.xml
echo "Configuring Agent properties: ${AGENT_CONFIG}"
sed -i "s/<controller-host>/<controller-host>${CONTROLLER}/g" ${AGENT_CONFIG}
echo " controller-host: ${CONTROLLER}"
sed -i "s/<controller-port>/<controller-port>${APPD_PORT}/g" ${AGENT_CONFIG}
echo " controller-port: ${APPD_PORT}"
sed -i "s/<account-access-key>/<account-access-key>${ACCESS_KEY}/g" ${AGENT_CONFIG}
echo " account-access-key: ${ACCESS_KEY}"
sed -i "s/<application-name>/<application-name>${APP_NAME}/g" ${AGENT_CONFIG}
echo " application-name: ${APP_NAME}"
sed -i "s/<tier-name>/<tier-name>${TIER_NAME}/g" ${AGENT_CONFIG}
echo " tier-name: ${TIER_NAME}"
sed -i "s/<node-name>/<node-name>${NODE_NAME}/g" ${AGENT_CONFIG}
echo " node-name: ${NODE_NAME}"
sed -i "s/<sim-enabled>false/<sim-enabled>true/g" ${AGENT_CONFIG}
echo " sim-enabled: true"
#sed -i "s/<unique-host-id>/<unique-host-id>${UNIQUE_HOST_ID}/g" ${AGENT_CONFIG}
#echo " unique-host-id: ${UNIQUE_HOST_ID}"
sed -i "s/<machine-path>/<machine-path>${MACHINE_PATH_1}|${MACHINE_PATH_2}/g" ${AGENT_CONFIG}
echo " machine-path: ${MACHINE_PATH_1}|${MACHINE_PATH_2}"

# Uncomment for multi-tenant controllers
# sed -i "s/<account-name>/<account-name>${ACCOUNT_NAME%%_*}/g" ${AGENT_CONFIG}
# echo " account-name: ${ACCOUNT_NAME%%_*}/g"

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
