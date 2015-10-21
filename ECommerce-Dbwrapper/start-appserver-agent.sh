#!/bin/sh
source /env.sh

CONTROLLER_INFO_SETTINGS="s/CONTROLLERHOST/${CONTROLLER}/g;
s/CONTROLLERPORT/${APPD_PORT}/g;
s/APP/${APP_NAME}/g;
s/TIER/${TIER_NAME}/g;
s/NODE/${NODE_NAME}/g;
s/FOO/${SIM_HIERARCHY_1}/g;
s/BAR/${SIM_HIERARCHY_2}/g;
s/BAZ/${HOSTNAME}/g;
s/ACCOUNTACCESSKEY/${ACCESS_KEY}/g"

sed -e "${CONTROLLER_INFO_SETTINGS}" /controller-info.xml > ${CATALINA_HOME}/appagent/conf/controller-info.xml

echo "Starting Tomcat with App Server Agent..."
echo APP_AGENT_JAVA_OPTS: ${APP_AGENT_JAVA_OPTS};
echo JMX_OPTS: ${JMX_OPTS}
cd ${CATALINA_HOME}/bin;
java -javaagent:${CATALINA_HOME}/appagent/javaagent.jar ${APP_AGENT_JAVA_OPTS} ${JMX_OPTS} -cp ${CATALINA_HOME}/bin/bootstrap.jar:${CATALINA_HOME}/bin/tomcat-juli.jar org.apache.catalina.startup.Bootstrap > appserver-agent-startup.out 2>&1
