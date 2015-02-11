#!/bin/bash

# Read env vars for Controller, Port, App, Tier and Node names
source /opt/appdynamics/env.sh
HTTPD24=/opt/rh/httpd24/root/etc/httpd

# Configure Apache for AppDynamics env vars
sed -i "s/<your_controller>/${CONTROLLER}/g" $HTTPD24/conf.d/appd.conf
sed -i "s/<your_controller_port>/${APPD_PORT}/g" $HTTPD24/conf.d/appd.conf
sed -i "s/<your_app_name>/${APP_NAME}/g" $HTTPD24/conf.d/appd.conf
sed -i "s/<your_tier_name>/${NODE_NAME}/g" $HTTPD24/conf.d/appd.conf
sed -i "s/<your_node_name>/${TIER_NAME}/g" $HTTPD24/conf.d/appd.conf

# Set Apache ServerName usign container's hostname
echo "ServerName `hostname`:80" >> $HTTPD24/conf/httpd.conf

# Start Apache and AppDynamics Proxy Agent
service httpd24-httpd start
nohup /opt/appdynamics/appdynamics-sdk-native/runSDKProxy.sh &
