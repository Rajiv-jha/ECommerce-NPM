#!/bin/bash

# Read env vars for Controller, Port, App, Tier and Node names
source ${NATIVE_HOME}/env.sh

/etc/init.d/httpd24-httpd stop

ln -s ${NATIVE_HOME}/WebServerAgent/Apache/libmod_appdynamics.so $HTTPD24/modules/mod_appdynamics.so

# Set Apache ServerName using container's hostname
echo "ServerName `hostname`:80" >> $HTTPD24/conf/httpd.conf

# Configure Controller, Port, App, Tier and Node for mod_appdynamics
sed -i "s/<your_controller>/${CONTROLLER}/g" $HTTPD_24/02-appd.conf
sed -i "s/<your_controller_port>/${APPD_PORT}/g" $HTTPD_24/02-appd.conf
sed -i "s/<your_app_name>/${APP_NAME}/g" $HTTPD_24/02-appd.conf
sed -i "s/<your_tier_name>/${TIER_NAME}/g" $HTTPD_24/02-appd.conf
sed -i "s/<your_node_name>/${NODE_NAME}/g" $HTTPD_24/02-appd.conf
mv ${HTTPD_24}/02-appd.conf ${HTTPD_24}/conf.modules.d/02-appd.conf

#Replacing CDN endpoint for early access to JS Agent
sed -i "s/cdn.appdynamics.com/s3-us-west-1.amazonaws.com\/jsagent-trunk.appdynamics.com/;" ${HTTPD_DOC_ROOT}/adrum.js

# Configure Controller, Port, App, Tier and Node for Proxy Agent
# Account Access Key is required for 4.1 Agents
CONTROLLER_INFO_SETTINGS="s/CONTROLLERHOST/${CONTROLLER}/g;
s/CONTROLLERPORT/${APPD_PORT}/g;
s/APP/${APP_NAME}/g;s/TIER/${TIER_NAME}/g;
s/NODE/${NODE_NAME}/g;
s/FOO/${SIM_HIERARCHY_1}/g;
s/BAR/${SIM_HIERARCHY_2}/g;
s/BAZ/${HOSTNAME}/g;
s/ACCOUNTACCESSKEY/${ACCESS_KEY}/g"

sed -e "${CONTROLLER_INFO_SETTINGS}" /controller-info.xml > ${NATIVE_HOME}/proxy/conf/controller-info.xml

# Run with docker run [...] -e NO_AGENT=true appdynamics/ecommerce-lbr to disable Web Server Agent/Proxy
if [ -z "${NO_AGENT}" ]; then 
  echo "Starting Proxy Agent"
  su apache -c "nohup ${NATIVE_HOME}/runSDKProxy.sh &"
  echo 'export APPD_SDK_ENV_LOG_CONFIG_PATH=/$NATIVE_HOMEconf/appdynamics_sdk_log4cxx.xml' >>  /home/apache/.bash_profile
else
  rm ${HTTPD_24}/02-appd.conf
fi

/etc/init.d/httpd24-httpd start

# Start Machine Agent 
# NOTE: Machine Agent/Web Server Agent race condition
# Start manually with: docker exec lbr /start-machine-agent.sh
# ${MACHINE_AGENT_HOME}/start-machine-agent.sh
