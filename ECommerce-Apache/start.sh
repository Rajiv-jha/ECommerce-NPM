#!/bin/bash

# Read env vars for Controller, Port, App, Tier and Node names
source /opt/appdynamics/env.sh
HTTPD24=/opt/rh/httpd24/root/etc/httpd

# Configure Apache for AppDynamics env vars
sed -i "s/<your_controller>/${CONTROLLER}/g" $HTTPD24/conf.d/appd.conf
sed -i "s/<your_controller_port>/${APPD_PORT}/g" $HTTPD24/conf.d/appd.conf
sed -i "s/<your_app_name>/${APP_NAME}/g" $HTTPD24/conf.d/appd.conf
sed -i "s/<your_tier_name>/${TIER_NAME}/g" $HTTPD24/conf.d/appd.conf
sed -i "s/<your_node_name>/${NODE_NAME}/g" $HTTPD24/conf.d/appd.conf

# Set Apache ServerName usign container's hostname
echo "ServerName `hostname`:80" >> $HTTPD24/conf/httpd.conf

# Start Apache AppDynamics Proxy Agent
export APPD_SDK_ENV_LOG_CONFIG_PATH=/opt/appdynamics/appdynamics-sdk-native/conf/appdynamics_sdk_log4cxx.xml
/etc/init.d/httpd24-httpd start

# Start AppDynamics Proxy Agent
echo "Starting Proxy Agent"
nohup /opt/appdynamics/appdynamics-sdk-native/runSDKProxy.sh &

# Wait for Proxy Agent to register with the Controller
sleep 60

# Start Machine Agent
echo "Starting Machine Agent..."
nohup java ${AGENT_OPTS} -jar ${MACHINE_AGENT_HOME}/machineagent.jar  > ${MACHINE_AGENT_HOME}/machine_agent.log &
