#!/bin/bash

# Set correct variables
source /env.sh

# Configure analytics-agent.properties
aaprop=${MACHINE_AGENT_HOME}/monitors/analytics-agent/conf/analytics-agent.properties

if [ "$(grep '^http.event.endpoint=http://localhost:9080/v1' $aaprop)" ]; then
        echo "${aaprop}: setting event.endpoint: ${EVENT_ENDPOINT}"
	sed -i "/^http.event.endpoint=/c\http.event.endpoint=${EVENT_ENDPOINT}\/v1" ${aaprop}
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
