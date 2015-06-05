#! /bin/bash

if [ $1 == "rpm" ]; then
  EXEC_ARGS="-t"
elif [ $1 == "zip" ]; then
  EXEC_ARGS=""
else
  echo "Error: must specify zip or rpm"
  exit
fi

echo "Starting machine agent on web container..."; docker exec ${EXEC_ARGS} web /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on web1 container..."; docker exec ${EXEC_ARGS} web1 /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on ws container..."; docker exec ${EXEC_ARGS} ws /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on msg container..."; docker exec ${EXEC_ARGS} msg /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on fulfillment container..."; docker exec ${EXEC_ARGS} fulfillment /start-machine-agent.sh; echo "Done"
echo "Starting machine agent on fulfillment-client container..."; docker exec ${EXEC_ARGS} fulfillment-client /start-machine-agent.sh; echo "Done"
sleep 60
echo "Starting machine agent on lbr container..."; docker exec ${EXEC_ARGS} lbr /start-machine-agent.sh; echo "Done"
