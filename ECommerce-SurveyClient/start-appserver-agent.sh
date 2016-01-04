#!/bin/sh
source /env.sh

# Uncomment to configure Agents using controller-info.xml
AGENT_CONFIG=${CATALINA_HOME}/appagent/conf/controller-info.xml
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

# Uncomment for multi-tenant controllers
# sed -i "s/<account-name>/<account-name>${ACCOUNT_NAME%%_*}/g" ${AGENT_CONFIG}
# echo " account-name: ${ACCOUNT_NAME%%_*}/g"

sed -e "${CONTROLLER_INFO_SETTINGS}" /controller-info.xml > /${CLIENT_HOME}/appagent/conf/controller-info.xml
echo "Starting Client ...."
echo APP_AGENT_JAVA_OPTS: ${APP_AGENT_JAVA_OPTS};
echo JMX_OPTS: ${JMX_OPTS}
cd ${CATALINA_HOME}/bin;
java -javaagent:${CLIENT_HOME}/appagent/javaagent.jar ${APP_AGENT_JAVA_OPTS} ${JMX_OPTS} -jar ${CLIENT_HOME}/ECommerce-SurveyClient-1.0.jar
