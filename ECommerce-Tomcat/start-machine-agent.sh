#!/bin/sh

source /env.sh

sed -e "s/CONTROLLERHOST/${CONTROLLER}/g;s/CONTROLLERPORT/${APPD_PORT}/g;s/APP/${APP_NAME}/g;s/TIER/${TIER_NAME}/g;s/NODE/${NODE_NAME}/g" /controller-info.xml > $MACHINE_AGENT_HOME/conf/controller-info.xml;
service appdynamics-machine-agent start
