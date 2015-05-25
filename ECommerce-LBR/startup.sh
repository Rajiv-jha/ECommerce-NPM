#!/bin/bash

# Read env vars for Controller, Port, App, Tier and Node names
source /opt/appdynamics-sdk-native/env.sh

/etc/init.d/httpd24-httpd stop

ln -s ${NATIVE_HOME}/WebServerAgent/Apache/libmod_appdynamics.so $HTTPD24/modules/mod_appdynamics.so

# Set Apache ServerName usign container's hostname
echo "ServerName `hostname`:80" >> $HTTPD24/conf/httpd.conf

sed -i "s/<your_controller>/${CONTROLLER}/g" $HTTPD_24/appd.conf
sed -i "s/<your_controller_port>/${APPD_PORT}/g" $HTTPD_24/appd.conf
sed -i "s/<your_app_name>/${APP_NAME}/g" $HTTPD_24/appd.conf
sed -i "s/<your_tier_name>/${TIER_NAME}/g" $HTTPD_24/appd.conf
sed -i "s/<your_node_name>/${NODE_NAME}/g" $HTTPD_24/appd.conf
mv ${HTTPD_24}/appd.conf ${HTTPD_24}/conf.modules.d/02-appd.conf
 
echo "Starting Proxy Agent"
su apache -c "nohup $NATIVE_HOME/runSDKProxy.sh &"

echo 'export APPD_SDK_ENV_LOG_CONFIG_PATH=/$NATIVE_HOMEconf/appdynamics_sdk_log4cxx.xml' >>  /home/apache/.bash_profile
/etc/init.d/httpd24-httpd start

# Start Machine Agent 
# NOTE: Machine Agent/Web Server Agent race condition
# Start manually with: docker exec lbr /start-machine-agent.sh
# ${MACHINE_AGENT_HOME}/start-machine-agent.sh
