#!/bin/bash

echo "restarting catalina"

CWD=${PWD}

source /env.sh

source /start-machine-agent.sh
source /start-appserver-agent.sh

cd ${CWD}


cd ${CATALINA_HOME}/bin

sh startup.sh

sleep 10
