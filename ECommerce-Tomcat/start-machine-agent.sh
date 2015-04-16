#!/bin/sh

source /env.sh

/configAnalytics.sh

AVAIL_ZONE=`curl http://169.254.169.254//latest/meta-data/placement/availability-zone`

CLOUD_NAME=`curl http://169.254.169.254//latest/meta-data/public-hostname`

sed -e "s/CONTROLLERHOST/${CONTROLLER}/g;s/CONTROLLERPORT/${APPD_PORT}/g;s/APP/${APP_NAME}/g;s/TIER/${TIER_NAME}/g;s/NODE/${NODE_NAME}/g;s/FOO/${AVAIL_ZONE}/g;s/BAR/${CLOUD_NAME}/g;s/BAZ/${HOSTNAME}/g" /controller-info.xml > $MACHINE_AGENT_HOME/conf/controller-info.xml
service appdynamics-machine-agent start
