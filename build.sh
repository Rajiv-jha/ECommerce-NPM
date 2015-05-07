# This script is provided for illustration purposes only.
#
# To build the ECommerce demo application, you will need to download the following components:
# 1. An appropriate version of the Oracle Java 7 JDK
#    (http://www.oracle.com/technetwork/java/javase/downloads/index.html)
# 2. Correct versions for the AppDynamics AppServer Agent, Machine Agent and Database Monitoring Agent for your Controller installation
#    (https://download.appdynamics.com)
#
# To run the ECommerce demo application, you will also need to:
# 1. Build and run the ECommerce-Oracle docker container
#    The Dockerfile is available here (https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-Oracle)
#    The container requires you to downlaod an appropriate version of the Oracle Database Express Edition 11g Release 2
#    (http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html)
# 2. Download and run the official Docker mysql container
#    (https://registry.hub.docker.com/_/mysql/)
 
#! /bin/bash

cleanUp() {
  (cd ECommerce-Java && rm -f jdk-linux-x64.rpm)
  (cd ECommerce-Tomcat && rm -f AppServerAgent.zip MachineAgent.zip)
  (cd ECommerce-Tomcat && rm -rf monitors ECommerce-Java)
  (cd ECommerce-FulfillmentClient && rm -f AppServerAgent.zip MachineAgent.zip)
  (cd ECommerce-FulfillmentClient && rm -rf monitors ECommerce-Java)
  (cd ECommerce-Synapse && rm -f AppServerAgent.zip MachineAgent.zip)
  (cd ECommerce-DBAgent && rm -f dbagent.zip)
  (cd ECommerce-Load && rm -rf ECommerce-Load)
  (cd ECommerce-LBR && rm -f MachineAgent.zip webserver_agent.tar.gz)
  
  # Remove dangling images left-over from build
  if [[ `docker images -q --filter "dangling=true"` ]]
  then
    echo
    echo "Deleting intermediate containers..."
    docker images -q --filter "dangling=true" | xargs docker rmi;
  fi
}

promptForAgents() {
  read -e -p "Enter path to App Server Agent: " APP_SERVER_AGENT
  read -e -p "Enter path to Machine Agent: " MACHINE_AGENT
  read -e -p "Enter path to DB Agent: " DB_AGENT
  read -e -p "Enter path to Web Server Agent: " WEB_AGENT
  read -e -p "Enter Docker Version: " VERSION
}

# Usage information
if [[ $1 == *--help* ]]
then
  echo "Specify agent locations: build.sh -a <Path to App Server Agent> -m <Path to Machine Agent> -d <Path to Database Agent> -v <Version>"
  echo "Prompt for agent locations: build.sh"
  exit
fi

# Prompt for location of App Server, Machine and Database Agents
if  [ $# -eq 0 ]
then   
  promptForAgents

else
  # Allow user to specify locations of App Server, Machine and Database Agents
  while getopts "a:m:d:w:v:n:k:" opt; do
    case $opt in
      a)
        APP_SERVER_AGENT=$OPTARG
        if [ ! -e ${APP_SERVER_AGENT} ]
        then
          echo "Not found: ${APP_SERVER_AGENT}"
          exit
        fi
        ;;
      m)
        MACHINE_AGENT=$OPTARG
        if [ ! -e ${MACHINE_AGENT} ]
        then
          echo "Not found: ${MACHINE_AGENT}"
          exit
        fi
        ;;
      d)
        DB_AGENT=$OPTARG
        if [ ! -e ${DB_AGENT} ]
        then
          echo "Not found: ${DB_AGENT}"
          exit
        fi
        ;;
      w)
        WEB_AGENT=$OPTARG
        if [ ! -e ${WEB_AGENT} ]
        then
          echo "Not found: ${WEB_AGENT}"
          exit
        fi
        ;; 
      v)
        VERSION=$OPTARG 
        if [ -e ${VERSION} ]
        then
          VERSION=latest;
          echo "Version Not found using: ${VERSION}"          
        fi
        ;;               
      n)
        ANALYTICS_ACCOUNT_NAME=$OPTARG
        ;;
      k)
        ANALYTICS_ACCOUNT_KEY=$OPTARG
        ;;
      \?)
        echo "Invalid option: -$OPTARG"
        ;;
    esac
  done
fi

# Pull Java base image from (private) appdynamics docker repo
# docker pull appdynamics/ecommerce-java:oracle-java7

# Download Oracle JDK7 and build ecommerce-java base image
echo "Building ECommerce-Java base image..."
(cd ECommerce-Java; curl -j -k -L -H "Cookie:oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u71-b13/jdk-7u71-linux-x64.rpm -o jdk-linux-x64.rpm)
(cd ECommerce-Java; docker build -t appdynamics/ecommerce-java .)

# Copy Agent zips to build dirs
echo "Adding AppDynamics Agents ${APP_SERVER_AGENT} ${MACHINE_AGENT} ${WEB_AGENT} ${DB_AGENT}"
cp ${APP_SERVER_AGENT} ECommerce-Tomcat/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-Tomcat/MachineAgent.zip
echo "Copied Agents for ECommerce-Tomcat..."

cp ${APP_SERVER_AGENT} ECommerce-FulfillmentClient/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-FulfillmentClient/MachineAgent.zip
echo "Copied Agents for ECommerce-Tomcat..."

cp ${APP_SERVER_AGENT} ECommerce-Synapse/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-Synapse/MachineAgent.zip
echo "Copied Agents for ECommerce-Synapse..."

cp ${MACHINE_AGENT} ECommerce-DBAgent/MachineAgent.zip
echo "Copied Agents for ECommerce-DBAgent..."

cp ${WEB_AGENT} ECommerce-LBR/webserver_agent.tar.gz
cp ${MACHINE_AGENT} ECommerce-LBR/MachineAgent.zip
cp ${DB_AGENT} ECommerce-DBAgent/dbagent.zip
echo "Copied Agents for ECommerce-LBR..."

# Build Tomcat containers using downloaded AppServer and Machine Agents
echo "Building ECommerce-Tomcat..."
(cd ECommerce-Tomcat && git clone https://github.com/Appdynamics/ECommerce-Java.git)
(cd ECommerce-Tomcat && docker build -t appdynamics/ecommerce-tomcat:${VERSION} .)

echo "Building ECommerce-FulfillmentClient..."
(cd ECommerce-FulfillmentClient && git clone https://github.com/Appdynamics/ECommerce-Java.git)
(cd ECommerce-FulfillmentClient && docker build -t appdynamics/ecommerce-fulfillment-client:${VERSION} .)

# Build Synapse container using downloaded AppServer and Machine Agents
echo "Building ECommerce-Synapse..."
(cd ECommerce-Synapse && docker build -t appdynamics/ecommerce-synapse:${VERSION} .)

# Build DBAgent container using downloaded DBAgent
echo "Building ECommerce-DBAgent..."
(cd ECommerce-DBAgent && docker build -t appdynamics/ecommerce-dbagent:${VERSION} .)

# Build Web Agent container
echo "Building Web Agent container..."
(cd ECommerce-LBR && docker build -t appdynamics/ecommerce-lbr:${VERSION} .)

# Build LoadGen container
echo "Building ECommerce-Load..."
(cd ECommerce-Load && git clone https://github.com/Appdynamics/ECommerce-Load.git)
(cd ECommerce-Load && docker build -t appdynamics/ecommerce-load:${VERSION} .)

# Pull ActiveMQ, LBR and Oracle containers from (private) appdynamics docker repo
echo "Pulling ActiveMQ, LBR and Oracle database containers..."
#docker pull appdynamics/ecommerce-activemq:${VERSION}
#docker pull appdynamics/ecommerce-lbr:${VERSION}
docker pull appdynamics/ecommerce-oracle:${VERSION}

echo "Local docker container images installed: "
echo "    appdynamics/ecommerce-java:oracle-java7"
echo "    appdynamics/ecommerce-tomcat"
echo "    appdynamics/ecommerce-fulfillment-client"
echo "    appdynamics/ecommerce-synapse"
echo "    appdynamics/ecommerce-dbagent"
echo "    appdynamics/ecommerce-activemq"
echo "    appdynamics/ecommerce-lbr"
echo "    appdynamics/ecommerce-load"
echo "    appdynamics/ecommerce-oracle"

cleanUp
