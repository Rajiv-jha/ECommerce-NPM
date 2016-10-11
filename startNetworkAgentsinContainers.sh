# This script is provided for running network agents in the docker containers.
#
# Once you build and run the ECommerce, run the machine agents and followed by NetworkAgentsContainers
#
# This isn't a recommended way to do, we are doing as part of hack to see network flow maps


#! /bin/bash
promptForAgents(){

  read -e -p "Enter path to Network Agent (64bit-linux-<ver>.zip): " NETWORK_AGENT_PATH

}
RunAgents(){

echo "Copying Network Agent into Containers"

docker cp ${NETWORK_AGENT_PATH} msg:/Network-Agent.zip
docker cp ${NETWORK_AGENT_PATH} customer-survey:/Network-Agent.zip
docker cp ${NETWORK_AGENT_PATH} web1:/Network-Agent.zip
docker cp ${NETWORK_AGENT_PATH} fulfillment-client:/Network-Agent.zip
docker cp ${NETWORK_AGENT_PATH} fulfillment:/Network-Agent.zip
docker cp ${NETWORK_AGENT_PATH} web:/Network-Agent.zip
docker cp ${NETWORK_AGENT_PATH} ws:/Network-Agent.zip
docker cp ${NETWORK_AGENT_PATH} rds-dbwrapper:/Network-Agent.zip

echo "Running Network Agents in different Containers"

docker exec msg unzip /Network-Agent.zip -d /Network-Agent
echo "Installing Network agent on msg container..."; docker exec msg /Network-Agent/install.sh; echo "Done"
echo "Starting Network agent on msg container..."; docker exec msg /Network-Agent/bin/start.sh; echo "Done"

docker exec customer-survey unzip /Network-Agent.zip -d /Network-Agent
echo "Installing Network agent on customer-survey container..."; docker exec customer-survey /Network-Agent/install.sh; echo "Done"
echo "Starting Network agent on customer-survey container..."; docker exec customer-survey /Network-Agent/bin/start.sh; echo "Done"

docker exec web1 unzip /Network-Agent.zip -d /Network-Agent
decho "Installing Network agent on web1 container..."; docker exec web1 /Network-Agent/install.sh; echo "Done"
echo "Starting Network agent on web1 container..."; docker exec web1 /Network-Agent/bin/start.sh; echo "Done"

docker exec -i fulfillment-client unzip /Network-Agent.zip -d /Network-Agent
echo "Installing Network agent on fulfillment-client container..."; docker exec fulfillment-client /Network-Agent/install.sh; echo "Done"
echo "Starting Network agent on fulfillment-client container..."; docker exec fulfillment-client /Network-Agent/bin/start.sh; echo "Done"

docker exec -i fulfillment unzip /Network-Agent.zip -d /Network-Agent
echo "Installing Network agent on fulfillment container..."; docker exec fulfillment /Network-Agent/install.sh; echo "Done"
echo "Starting Network agent on fulfillment container..."; docker exec fulfillment /Network-Agent/bin/start.sh; echo "Done"

docker exec -i web unzip /Network-Agent.zip -d /Network-Agent
echo "Installing Network agent on web container..."; docker exec web /Network-Agent/install.sh; echo "Done"
echo "Starting Network agent on web container..."; docker exec web /Network-Agent/bin/start.sh; echo "Done"

docker exec -i ws unzip /Network-Agent.zip -d /Network-Agent
echo "Installing Network agent on ws container..."; docker exec ws /Network-Agent/install.sh; echo "Done"
echo "Starting Network agent on ws container..."; docker exec ws /Network-Agent/bin/start.sh; echo "Done"

docker exec -i rds-dbwrapper unzip /Network-Agent.zip -d /Network-Agent
echo "Installing Network agent on rds-dbwrapper container..."; docker exec rds-dbwrapper /Network-Agent/install.sh; echo "Done"
echo "Starting Network agent on rds-dbwrapper container..."; docker exec rds-dbwrapper /Network-Agent/bin/start.sh; echo "Done"

}

if  [ $# -eq 0 ]
then
  promptForAgents
else
  # Allow user to specify locations of Agent installers
  while getopts "n" opt; do
    case $opt in
      n)
        NETWORK_AGENT_PATH=$OPTARG
        if [ ! -e ${NETWORK_AGENT_PATH} ]; then
          echo "Not found: ${NETWORK_AGENT_PATH}"; exit 1
        fi
        ;;
      \?)
        echo "Invalid option: -$OPTARG"
        ;;
    esac
  done
fi

RunAgents


