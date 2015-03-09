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

source /start-machine-agent.sh

APP_AGENT_JAVA_OPTS="${MACHINE_AGENT_JAVA_OPTS} -DjvmRoute=${JVM_ROUTE} -Xmx512m -XX:MaxPermSize=128m -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager";
echo "Starting Tomcat with App Server Agent..."
echo APP_AGENT_JAVA_OPTS: $APP_AGENT_JAVA_OPTS;
echo JMX_OPTS: ${JMX_OPTS}
cd ${CATALINA_HOME}/bin;
java -javaagent:${CATALINA_HOME}/appagent/javaagent.jar ${APP_AGENT_JAVA_OPTS} ${JMX_OPTS} -cp ${CATALINA_HOME}/bin/bootstrap.jar:${CATALINA_HOME}/bin/tomcat-juli.jar org.apache.catalina.startup.Bootstrap

cd ${CWD}
