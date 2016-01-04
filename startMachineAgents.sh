#! /bin/bash

USE_RPM=$(docker exec web ls /etc/init.d/appdynamics-machine-agent 2> /dev/null)

if [ -z ${USE_RPM} ]; then
  EXEC_ARGS=""
elif [ ${USE_RPM} == "/etc/init.d/appdynamics-machine-agent" ]; then
  EXEC_ARGS="-t"
else
  EXEC_ARGS=""
fi

echo "Starting machine agent on web container..."; docker exec ${EXEC_ARGS} web /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on web1 container..."; docker exec ${EXEC_ARGS} web1 /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on ws container..."; docker exec ${EXEC_ARGS} ws /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on msg container..."; docker exec ${EXEC_ARGS} msg /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on fulfillment container..."; docker exec ${EXEC_ARGS} fulfillment /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on fulfillment-client container..."; docker exec ${EXEC_ARGS} fulfillment-client /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on rds-dbwrapper container..."; docker exec ${EXEC_ARGS} rds-dbwrapper /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on customer-survey container..."; docker exec ${EXEC_ARGS} customer-survey /start-machine-agent.sh; echo "Done"

sleep 60
echo "Starting machine agent on lbr container..."; docker exec ${EXEC_ARGS} lbr /start-machine-agent.sh; echo "Done"
