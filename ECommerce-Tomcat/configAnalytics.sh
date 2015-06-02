#!/bin/bash

# Set correct variables
source /env.sh

# Configure analytics-agent.properties
aaprop=${MACHINE_AGENT_HOME}/monitors/analytics-agent/conf/analytics-agent.properties

if [ "$(grep '^http.event.endpoint=http://localhost:9080/v1' $aaprop)" ]; then
        echo "${aaprop}: setting event.endpoint: ${EVENT_ENDPOINT}"
	sed -i "/^http.event.endpoint=/c\http.event.endpoint=http:\/\/${EVENT_ENDPOINT}\/v1" ${aaprop}
else
        echo "${aaprop}: endpoint already set or doesn't exist"
fi

if [ "$(grep '^http.event.accountName=analytics-customer1$' $aaprop)" ]; then
        echo "${aaprop}: setting event.accountName: ${ACCOUNT_NAME}"
	sed -i "/^http.event.accountName=/c\http.event.accountName=${ACCOUNT_NAME}" ${aaprop}
else
        echo "${aaprop}: account name already set or doesn't exist"
fi

if [ "$(grep '^http.event.accessKey=your-account-access-key$' $aaprop)" ]; then
        echo "${aaprop}: setting event.accessKey: ${ACCESS_KEY}"
        sed -i "/^http.event.accessKey=/c\http.event.accessKey=${ACCESS_KEY}" ${aaprop}
else
        echo "${aaprop}: accessKey already set or doesn't exist"
fi

# Configure monitor.xml
monxml=${MACHINE_AGENT_HOME}/monitors/analytics-agent/monitor.xml

if [ "$(grep '<enabled>false</enabled>' $monxml)" ]; then
        echo "${monxml}: setting to "true""
	sed -i 's#<enabled>false</enabled>#<enabled>true</enabled>#g' ${monxml}
else
        echo "${monxml}: already enabled or doesn't exist"
fi

ecjl=${MACHINE_AGENT_HOME}/monitors/analytics-agent/conf/job/ecommerce-log4j.job

if [ "$(grep '_NODE_NAME' ${ecjl})" ]; then
        echo "${ecjl}: setting NODE_NAME to "${NODE_NAME}""
        sed -i "s/_NODE_NAME/${NODE_NAME}/g" ${ecjl}
else
        echo "Error configuring ${ecjl}: _NODE_NAME not found"
fi

if [ "$(grep '_TIER_NAME' ${ecjl})" ]; then
        echo "${ecjl}: setting TIER_NAME to "${TIER_NAME}""
        sed -i "s/_TIER_NAME/${TIER_NAME}/g" ${ecjl}
else
        echo "Error configuring ${ecjl}: _TIER_NAME not found"
fi

if [ "$(grep '_APP_NAME' ${ecjl})" ]; then
        echo "${ecjl}: setting APP_NAME to "${APP_NAME}""
        sed -i "s/_APP_NAME/${APP_NAME}/g" ${ecjl}
else
        echo "Error configuring ${ecjl}: _APP_NAME not found"
fi
