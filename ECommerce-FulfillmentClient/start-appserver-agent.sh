#!/bin/sh

source /env.sh

echo "Starting Client ...."
echo APP_AGENT_JAVA_OPTS: ${APP_AGENT_JAVA_OPTS};
echo JMX_OPTS: ${JMX_OPTS}
cd ${CATALINA_HOME}/bin;
java -javaagent:${CLIENT_HOME}/appagent/javaagent.jar ${APP_AGENT_JAVA_OPTS} ${JMX_OPTS} -jar ${CLIENT_HOME}/ECommerce-FulfillmentClient.jar
