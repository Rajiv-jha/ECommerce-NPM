#!/bin/bash
CWD=${PWD}


source /env.sh

if [ "${create_schema}" == "true" ]; then
	cd /ECommerce-Java;gradle createDB
fi

if [ -n "${web}" ]; then
        cp  /ECommerce-Java/ECommerce-Web/build/libs/appdynamicspilot.war /tomcat/webapps;
fi

if [ -n "${jms}" ]; then
 	cp /ECommerce-Java/ECommerce-JMS/build/libs/appdynamicspilotjms.war /tomcat/webapps;
fi

if [ -n "${ws}" ]; then
        cp /ECommerce-Java/ECommerce-WS/build/libs/cart.war /tomcat/webapps;
fi

JAVA_OPTS="-Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT} -Dappdynamics.agent.applicationName=${APP_NAME} -Dappdynamics.agent.tierName=${TIER_NAME} -Dappdynamics.agent.nodeName=${NODE_NAME}";
JMX_OPTS="-Dcom.sun.management.jmxremote.port=8888  -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
echo "Starting Machine Agent..."

echo java ${JAVA_OPTS} -jar ${MACHINE_AGENT_HOME}/machineagent.jar


nohup java ${JAVA_OPTS} -jar ${MACHINE_AGENT_HOME}/machineagent.jar  > ${MACHINE_AGENT_HOME}/machine_agent.log 2>&1 &

JAVA_OPTS="${JAVA_OPTS} -DjvmRoute=${JVM_ROUTE} -Xmx512m -XX:MaxPermSize=128m -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager";

echo $JAVA_OPTS;

cd ${CATALINA_HOME}/bin;

java -javaagent:${CATALINA_HOME}/appagent/javaagent.jar ${JAVA_OPTS} ${JMX_OPTS} -cp ${CATALINA_HOME}/bin/bootstrap.jar:${CATALINA_HOME}/bin/tomcat-juli.jar org.apache.catalina.startup.Bootstrap

cd ${CWD}
