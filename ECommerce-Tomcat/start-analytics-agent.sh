#!/bin/sh

source /env.sh

echo "Configuring Machine Agent Analytics properties..."
/configAnalyticsAgent.sh

echo "Starting Analytics Agent..."
(cd /analytics-agent; sh bin/analytics-agent start)
