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
  (cd ECommerce-Tomcat && rm -f AppServerAgent.zip ${MACHINE_AGENT} AnalyticsAgent.zip Dockerfile)
  (cd ECommerce-Tomcat && rm -rf monitors ECommerce-Java)
  (cd ECommerce-FulfillmentClient && rm -f AppServerAgent.zip ${MACHINE_AGENT} Dockerfile)
  (cd ECommerce-FulfillmentClient && rm -rf monitors ECommerce-Java)
  (cd ECommerce-Synapse && rm -f AppServerAgent.zip ${MACHINE_AGENT} Dockerfile)
  (cd ECommerce-DBAgent && rm -f dbagent.zip)
  (cd ECommerce-Load && rm -rf ECommerce-Load)
  (cd ECommerce-LBR && rm -f ${MACHINE_AGENT} webserver_agent.tar.gz Dockerfile)
  rm -f ${MACHINE_AGENT}
 
  # Remove dangling images left-over from build
  if [[ `docker images -q --filter "dangling=true"` ]]
  then
    echo
    echo "Deleting intermediate containers..."
    docker images -q --filter "dangling=true" | xargs docker rmi;
  fi
}
trap cleanUp EXIT

promptForAgents() {
  read -e -p "Enter path to App Server Agent: " APP_SERVER_AGENT
  read -e -p "Enter path to Machine Agent: " MACHINE_AGENT
  read -e -p "Enter path to DB Agent: " DB_AGENT
  read -e -p "Enter path to Web Server Agent: " WEB_AGENT
  read -e -p "Enter path to Analytics Agent: " ANALYTICS_AGENT
  read -e -p "Enter Docker Version: " VERSION
}

# Usage information
if [[ $1 == *--help* ]]
then
  echo "Specify agent locations: build.sh -a <Path to App Server Agent> -m <Path to Machine Agent> -d <Path to Database Agent> -w <Path to Web Server Agent> -y <Path to Analytics Agent>"
  echo "Prompt for agent locations: build.sh"
  exit
fi

# Prompt for location of App Server, Machine and Database Agents
if  [ $# -eq 0 ]
then   
  promptForAgents

else
  # Allow user to specify locations of App Server, Machine and Database Agents
  while getopts "a:m:d:w:v:y:" opt; do
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
        export MACHINE_AGENT=$OPTARG
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
      y)
        ANALYTICS_AGENT=$OPTARG 
	if [ ! -e ${ANALYTICS_AGENT} ]
        then
          echo "Not found: ${ANALYTICS_AGENT}"
	  exit         
        fi
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
echo; echo "Building ECommerce-Java base image..."
echo "Downloading Oracle Java 7 JDK"
(cd ECommerce-Java; curl -j -k -L -H "Cookie:oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u71-b13/jdk-7u71-linux-x64.rpm -o jdk-linux-x64.rpm)
echo "Building ECommerce-Java..."
(cd ECommerce-Java; docker build -t appdynamics/ecommerce-java .)
echo

MACHINE_AGENT_INPUT=${MACHINE_AGENT}
if [ ${MACHINE_AGENT: -4} == ".zip" ]
then
	# Add Machine Agent zip install to Dockerfiles 
	source ./makeDockerfiles.sh zip
        cp ${MACHINE_AGENT} MachineAgent.zip
        MACHINE_AGENT="MachineAgent.zip"        
elif [ ${MACHINE_AGENT: -4} == ".rpm" ]
then
	# Add Machine Agent rpm install to Dockerfiles 
	source ./makeDockerfiles.sh rpm
        cp ${MACHINE_AGENT} machineagent.rpm
        MACHINE_AGENT="machineagent.rpm"
else
  echo "Machine agent file extension not recognized"
  exit
fi

# Copy Agent zips to build dirs
echo "Adding AppDynamics Agents: 
${APP_SERVER_AGENT} 
${MACHINE_AGENT_INPUT} 
${WEB_AGENT} 
${DB_AGENT}"

cp ${APP_SERVER_AGENT} ECommerce-Tomcat/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-Tomcat/${MACHINE_AGENT}

if [ -z ${ANALYTICS_AGENT} ]
then
  echo "Skipping standalone Analytics Agent install"
else
  echo "Installing standalone Analytics Agent"
  echo ${ANALYTICS_AGENT}
  cp ${ANALYTICS_AGENT} ECommerce-Tomcat/AnalyticsAgent.zip
  (cd ECommerce-Tomcat; sed -i ${SED_OPTS} '/# Analytics Agent Install/ r Dockerfile.include.analytics-agent' Dockerfile; rm -f Dockerfile.bak)
fi
echo "Copied Agents for ECommerce-Tomcat"

cp ${APP_SERVER_AGENT} ECommerce-FulfillmentClient/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-FulfillmentClient/${MACHINE_AGENT}
echo "Copied Agents for ECommerce-FulfillmentClient"

cp ${APP_SERVER_AGENT} ECommerce-Synapse/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-Synapse/${MACHINE_AGENT}
echo "Copied Agents for ECommerce-Synapse"

cp ${WEB_AGENT} ECommerce-LBR/webserver_agent.tar.gz
cp ${MACHINE_AGENT} ECommerce-LBR/${MACHINE_AGENT}
cp ${DB_AGENT} ECommerce-DBAgent/dbagent.zip
echo "Copied Agents for ECommerce-LBR"

# Build Tomcat containers using downloaded AppServer and Machine Agents
echo; echo "Building ECommerce-Tomcat..." 
(cd ECommerce-Tomcat && git clone https://github.com/Appdynamics/ECommerce-Java.git)
(cd ECommerce-Tomcat && docker build -t appdynamics/ecommerce-tomcat:${VERSION} .)

echo; echo "Building ECommerce-FulfillmentClient..."
(cd ECommerce-FulfillmentClient && git clone https://github.com/Appdynamics/ECommerce-Java.git)
(cd ECommerce-FulfillmentClient && docker build -t appdynamics/ecommerce-fulfillment-client:${VERSION} .)

# Build Synapse container using downloaded AppServer and Machine Agents
echo; echo "Building ECommerce-Synapse..."
(cd ECommerce-Synapse && docker build -t appdynamics/ecommerce-synapse:${VERSION} .)

# Build DBAgent container using downloaded DBAgent
echo; echo "Building ECommerce-DBAgent..."
(cd ECommerce-DBAgent && docker build -t appdynamics/ecommerce-dbagent:${VERSION} .)

# Build Web Agent container
echo; echo "Building ECommerce-LBR..."
(cd ECommerce-LBR && docker build -t appdynamics/ecommerce-lbr:${VERSION} .)

# Build LoadGen container
echo; echo "Building ECommerce-Load..."
(cd ECommerce-Load && git clone https://github.com/Appdynamics/ECommerce-Load.git)
(cd ECommerce-Load && docker build -t appdynamics/ecommerce-load:${VERSION} .)
