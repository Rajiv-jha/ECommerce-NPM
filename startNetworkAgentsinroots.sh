# This script is provided for running network agents in the docker containers.
#
# Once you build and run the ECommerce, run the machine agents and followed by NetworkAgentinroots scripts
#
# This is a recommended way as per architecture
# ./startNetworkAgentsinroots.sh Network-Agents


#! /bin/bash
if [ -d Network-Agent ]; then
echo "Stopping Network Agents and removing directory..."
sudo sh ./Network-Agent/bin/stop.sh
rm -rf /Network-Agent
unzip ${1} -d Network-Agent/
echo "Installing Network agent ..."
sudo sh ./Network-Agent/install.sh
echo "Starting Network agent ..."
sudo sh ./Network-Agent/bin/start.sh

else
unzip ${1} -d Network-Agent/
echo "Installing Network agent ..."
sudo sh ./Network-Agent/install.sh
echo "Starting Network agent ..."
sudo sh ./Network-Agent/bin/start.sh
fi