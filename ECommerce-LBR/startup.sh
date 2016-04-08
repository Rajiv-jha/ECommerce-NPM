#!/bin/bash

# Read env vars for Controller, Port, App, Tier and Node names
source ${NATIVE_HOME}/env.sh
/etc/init.d/httpd24-httpd stop

# Set Apache ServerName using container's hostname
echo "ServerName `hostname`:80" >> ${HTTPD_24}/conf/httpd.conf

# Configure Controller, Port, App, Tier and Node for mod_appdynamics
sed -i "s/<your_controller>/${CONTROLLER}/g" ${HTTPD_24}/02-appd.conf
sed -i "s/<your_controller_port>/${APPD_PORT}/g" ${HTTPD_24}/02-appd.conf
sed -i "s/<your_app_name>/${APP_NAME}/g" ${HTTPD_24}/02-appd.conf
sed -i "s/<your_tier_name>/${TIER_NAME}/g" ${HTTPD_24}/02-appd.conf
sed -i "s/<your_node_name>/${NODE_NAME}/g" ${HTTPD_24}/02-appd.conf
sed -i "s/<your_account_name>/${ACCOUNT_NAME%%_*}/g" ${HTTPD_24}/02-appd.conf
sed -i "s/<your_access_key>/${ACCESS_KEY}/g" ${HTTPD_24}/02-appd.conf
mv ${HTTPD_24}/02-appd.conf ${HTTPD_24}/conf.modules.d/02-appd.conf

# Replacing CDN endpoint for early access to JS Agent
sed -i "s/cdn.appdynamics.com/s3-us-west-2.amazonaws.com\/adrum/g" ${HTTPD_DOC_ROOT}/adrum.js

# Run with docker run [...] -e NO_AGENT=true appdynamics/ecommerce-lbr to disable Web Server Agent/Proxy
if [ -z "${NO_AGENT}" ]; then 
  echo "Starting Proxy Agent"
  su apache -c "nohup ${NATIVE_HOME}/runSDKProxy.sh &"
else
  echo "AppDynamicsEnabled Off - Proxy Agent not started"
  sed -i s/"AppDynamicsEnabled On"/"AppDynamicsEnabled Off"/g ${HTTPD_24}/conf.modules.d/02-appd.conf
fi

/etc/init.d/httpd24-httpd start

# Start Machine Agent 
# NOTE: Machine Agent/Web Server Agent race condition
# Start manually with: docker exec lbr /start-machine-agent.sh
# ${MACHINE_AGENT_HOME}/start-machine-agent.sh
