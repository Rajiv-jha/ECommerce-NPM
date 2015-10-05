#!/bin/bash

# Replacing CDN endpoint for early access to JS Agent
#sed -i "s/cdn.appdynamics.com/s3-us-west-1.amazonaws.com\/jsagent-trunk.appdynamics.com/;" /adrum.js

CATALINA_HOME=/tomcat

export JAVA_OPTS="-Xmx512m -XX:MaxPermSize=128m"
${CATALINA_HOME}/bin/catalina.sh run 2>&1
