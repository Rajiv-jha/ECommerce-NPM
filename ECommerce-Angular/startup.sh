#!/bin/bash

CATALINA_HOME=/tomcat

export JAVA_OPTS="-Xmx512m -XX:MaxPermSize=128m"
${CATALINA_HOME}/bin/catalina.sh run 2>&1
