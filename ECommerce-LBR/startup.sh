#!/bin/bash

# Read env vars for Controller, Port, App, Tier and Node names
source /opt/appdynamics-sdk-native/env.sh

/etc/init.d/httpd24-httpd stop

HTTPD24=/opt/rh/httpd24/root/etc/httpd
ln -s $NATIVE_HOME/WebServerAgent/Apache/libmod_appdynamics.so $HTTPD24/modules/mod_appdynamics.so

# Configure Apache for AppDynamics env vars
#sed -i '1iSetEnv APPD_SDK_ENV_LOG_CONFIG_PATH ${NATIVE_HOME}/conf/appdynamics_sdk_log4cxx.xml' $HTTPD24/conf/httpd.conf

echo "Configuring Machine Agent in $MACHINE_AGENT_HOME"
source /opt/appdynamics-sdk-native/env.sh

AVAIL_ZONE=`curl http://169.254.169.254//latest/meta-data/placement/availability-zone`
CLOUD_NAME=`curl http://169.254.169.254//latest/meta-data/public-hostname`

sed -e "s/CONTROLLERHOST/${CONTROLLER}/g;s/CONTROLLERPORT/${APPD_PORT}/g;s/APP/${APP_NAME}/g;s/TIER/${TIER_NAME}/g;s/NODE/${NODE_NAME}/g;s/FOO/${AVAIL_ZONE}/g;s/BAR/${CLOUD_NAME}/g;s/BAZ/${HOSTNAME}/g" /controller-info.xml > $MACHINE_AGENT_HOME/conf/controller-info.xml;

#service appdynamics-machine-agent start

# Set Apache ServerName usign container's hostname
echo "ServerName `hostname`:80" >> $HTTPD24/conf/httpd.conf


sed -i "s/<your_controller>/${CONTROLLER}/g" $HTTPD24/appd.conf
sed -i "s/<your_controller_port>/${APPD_PORT}/g" $HTTPD24/appd.conf
sed -i "s/<your_app_name>/${APP_NAME}/g" $HTTPD24/appd.conf
sed -i "s/<your_tier_name>/${TIER_NAME}/g" $HTTPD24/appd.conf
sed -i "s/<your_node_name>/${NODE_NAME}/g" $HTTPD24/appd.conf
cat $HTTPD24/appd.conf >> $HTTPD24/conf/httpd.conf

echo "Starting Proxy Agent"
su  apache -c "nohup $NATIVE_HOME/runSDKProxy.sh &"

echo 'export APPD_SDK_ENV_LOG_CONFIG_PATH=/$NATIVE_HOMEconf/appdynamics_sdk_log4cxx.xml' >>  /home/apache/.bash_profile
/etc/init.d/httpd24-httpd stop
/etc/init.d/httpd24-httpd start


