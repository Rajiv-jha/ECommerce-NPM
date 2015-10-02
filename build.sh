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
  (cd ECommerce-Tomcat && rm -f AppServerAgent.zip ${MACHINE_AGENT} AnalyticsAgent.zip)
  (cd ECommerce-Tomcat && rm -rf monitors ECommerce-Java)
  (cd ECommerce-FulfillmentClient && rm -f AppServerAgent.zip ${MACHINE_AGENT})
  (cd ECommerce-FulfillmentClient && rm -rf monitors ECommerce-Java)
  (cd ECommerce-Synapse && rm -f AppServerAgent.zip ${MACHINE_AGENT})
  (cd ECommerce-DBAgent && rm -f dbagent.zip)
  (cd ECommerce-Load && rm -rf ECommerce-Load)
  (cd ECommerce-LBR && rm -f ${MACHINE_AGENT} webserver_agent.tar.gz adrum.*)
  (cd ECommerce-Angular && rm -rf ECommerce-Angular adrum.*)
  (cd ECommerce-FaultInjection && rm -rf ECommerce-FaultInjectionUI)
  (cd ECommerce-SurveyClient && rm -f AppServerAgent.zip ${MACHINE_AGENT})
  (cd ECommerce-SurveyClient && rm -rf monitors ECommerce-Java)
  (cd ECommerce-Dbwrapper && rm -rf AppServerAgent.zip ${MACHINE_AGENT} docker-dbwrapper)

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
  read -e -p "Enter path to Machine Agent: " MACHINE_AGENT_INPUT
  read -e -p "Enter path to DB Agent: " DB_AGENT
  read -e -p "Enter path to Web Server Agent: " WEB_AGENT
  read -e -p "Enter path to Javascript Agent: " ADRUM_AGENT
  read -e -p "Enter path to Analytics Agent: " ANALYTICS_AGENT
  read -e -p "Enter path to Oracle JDK7: " ORACLE_JDK7
}

# Usage information
if [[ $1 == *--help* ]]
then
  echo "Specify agent locations: build.sh
          -a <Path to App Server Agent>
          -m <Path to Machine Agent>
          -d <Path to Database Agent>
          -w <Path to Web Server Agent>
          -r <Path to JavaScript Agent>
          -y <Path to Analytics Agent>
          -j <Path to Oracle JDK7>"
  echo "Prompt for agent locations: build.sh"
  exit
fi

# Prompt for location of App Server, Machine and Database Agents
if  [ $# -eq 0 ]
then
  promptForAgents

else
  # Allow user to specify locations of App Server, Machine and Database Agents
  while getopts "a:m:d:w:r:y:j:" opt; do
    case $opt in
      a)
        APP_SERVER_AGENT=$OPTARG
        if [ ! -e ${APP_SERVER_AGENT} ]; then
          echo "Not found: ${APP_SERVER_AGENT}"; exit
        fi
        ;;
      m)
        export MACHINE_AGENT_INPUT=$OPTARG
        if [ ! -e ${MACHINE_AGENT_INPUT} ]; then
          echo "Not found: ${MACHINE_AGENT_INPUT}"; exit
        fi
        ;;
      d)
        DB_AGENT=$OPTARG
        if [ ! -e ${DB_AGENT} ]; then
          echo "Not found: ${DB_AGENT}"; exit
        fi
        ;;
      w)
        WEB_AGENT=$OPTARG
        if [ ! -e ${WEB_AGENT} ]; then
          echo "Not found: ${WEB_AGENT}"; exit
        fi
        ;;
      r)
        ADRUM_AGENT=$OPTARG
        if [ ! -e ${ADRUM_AGENT} ]; then
          echo "Not found: ${ADRUM_AGENT}"; exit
        fi
        ;;
      y)
        ANALYTICS_AGENT=$OPTARG
	if [ ! -e ${ANALYTICS_AGENT} ]; then
          echo "Not found: ${ANALYTICS_AGENT}"; exit
        fi
        ;;
      j)
        ORACLE_JDK7=$OPTARG
        if [ ! -e ${ORACLE_JDK7} ]; then
          echo "Not found: ${ORACLE_JDK7}"; exit
        fi
        ;;
      \?)
        echo "Invalid option: -$OPTARG"
        ;;
    esac
  done
fi

if [ -z ${APP_SERVER_AGENT} ]; then
    echo "Error: App Server Agent is required"; exit
fi

if [ -z ${MACHINE_AGENT_INPUT} ]; then
    echo "Error: Machine Agent is required"; exit
fi

if [ -z ${DB_AGENT} ]; then
    echo "Error: Database Agent is required"; exit
fi

if [ -z ${WEB_AGENT} ]; then
    echo "Error: Web Server Agent is required"; exit
fi

if [ -z ${ADRUM_AGENT} ]; then
    echo "Error: Javascript Agent is required"; exit
fi

# Download Oracle JDK7 and build ecommerce-java base image
echo; echo "Building ECommerce-Java base image..."

if [ -z ${ORACLE_JDK7} ]
then
    echo "Downloading Oracle Java 7 JDK"
    (cd ECommerce-Java; curl -j -k -L -H "Cookie:oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u71-b13/jdk-7u71-linux-x64.rpm -o jdk-linux-x64.rpm)
else
    echo "Using JDK: ${ORACLE_JDK7}"
    cp ${ORACLE_JDK7} ECommerce-Java/jdk-linux-x64.rpm
fi

echo "Building ECommerce-Java..."
(cd ECommerce-Java; docker build -t appdynamics/ecommerce-java .)
echo

# If supplied, add standalone analytics agent to build
if [ -z ${ANALYTICS_AGENT} ]
then
    echo "Skipping standalone Analytics Agent install"
else
    echo "Installing standalone Analytics Agent"
    echo "  ${ANALYTICS_AGENT}"
    cp ${ANALYTICS_AGENT} ECommerce-Tomcat/AnalyticsAgent.zip

    # Add analytics agent when creating Dockerfile for machine agent
    DOCKERFILE_OPTIONS="analytics"
fi

if [ ${MACHINE_AGENT_INPUT: -4} == ".zip" ]
then
    source ./makeDockerfiles.sh zip ${DOCKERFILE_OPTIONS}
    cp ${MACHINE_AGENT_INPUT} MachineAgent.zip
    MACHINE_AGENT="MachineAgent.zip"
elif [ ${MACHINE_AGENT_INPUT: -4} == ".rpm" ]
then
    source ./makeDockerfiles.sh rpm ${DOCKERFILE_OPTIONS}
    cp ${MACHINE_AGENT_INPUT} machineagent.rpm
    MACHINE_AGENT="machineagent.rpm"
else
    echo "Machine agent file extension not recognized"
    exit
fi

# Copy Agent zips to build dirs
echo "Adding AppDynamics Agents:
  ${APP_SERVER_AGENT}
  ${WEB_AGENT}
  ${DB_AGENT}
  ${MACHINE_AGENT_INPUT}
  ${ADRUM_AGENT}"

cp ${APP_SERVER_AGENT} ECommerce-Tomcat/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-Tomcat/${MACHINE_AGENT}
echo "Copied Agents for ECommerce-Tomcat"

cp ${APP_SERVER_AGENT} ECommerce-FulfillmentClient/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-FulfillmentClient/${MACHINE_AGENT}
echo "Copied Agents for ECommerce-FulfillmentClient"

cp ${APP_SERVER_AGENT} ECommerce-SurveyClient/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-SurveyClient/${MACHINE_AGENT}
echo "Copied Agents for ECommerce-SurveyClient"

cp ${APP_SERVER_AGENT} ECommerce-Synapse/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-Synapse/${MACHINE_AGENT}
echo "Copied Agents for ECommerce-Synapse"

cp ${WEB_AGENT} ECommerce-LBR/webserver_agent.tar.gz
cp ${ADRUM_AGENT} ECommerce-LBR/adrum.zip
(cd ECommerce-LBR; unzip adrum.zip; mv adrum*.js adrum.js; rm adrum.zip)
cp ${MACHINE_AGENT} ECommerce-LBR/${MACHINE_AGENT}
echo "Copied Agents for ECommerce-LBR"

cp ${DB_AGENT} ECommerce-DBAgent/dbagent.zip
echo "Copied Agents for ECommerce-DBAgent"

cp ${ADRUM_AGENT} ECommerce-Angular/adrum.zip
echo "Copied Agents for ECommerce-Angular"

cp ${MACHINE_AGENT} ECommerce-Dbwrapper/${MACHINE_AGENT}
cp ${APP_SERVER_AGENT} ECommerce-Dbwrapper/AppServerAgent.zip
echo "Copied Agents for ECommerce-Dbwrapper"

# Build Tomcat containers
echo; echo "Building ECommerce-Tomcat..."
(cd ECommerce-Tomcat && git clone -b cxf_to_jaxws https://github.com/Appdynamics/ECommerce-Java.git)
(cd ECommerce-Tomcat && docker build -t appdynamics/ecommerce-tomcat .)

echo; echo "Building ECommerce-FulfillmentClient..."
(cd ECommerce-FulfillmentClient && git clone -b cxf_to_jaxws https://github.com/Appdynamics/ECommerce-Java.git)
(cd ECommerce-FulfillmentClient && docker build -t appdynamics/ecommerce-fulfillment-client .)

echo; echo "Building ECommerce-Customer Survey Client..."
(cd ECommerce-SurveyClient && git clone -b cxf_to_jaxws https://github.com/Appdynamics/ECommerce-Java.git)
(cd ECommerce-SurveyClient && docker build -t appdynamics/ecommerce-survey-client .)

# Build Synapse container
echo; echo "Building ECommerce-Synapse..."
(cd ECommerce-Synapse && docker build -t appdynamics/ecommerce-synapse .)

# Build DBAgent container
echo; echo "Building ECommerce-DBAgent..."
(cd ECommerce-DBAgent && docker build -t appdynamics/ecommerce-dbagent .)

# Build Web Agent container
echo; echo "Building ECommerce-LBR..."
(cd ECommerce-LBR && docker build -t appdynamics/ecommerce-lbr .)

# Build Angular container
echo; echo "Building ECommerce-Angular..."
(cd ECommerce-Angular && git clone https://github.com/Appdynamics/ECommerce-Angular.git)
(cd ECommerce-Angular; unzip adrum.zip; mv adrum*.js adrum.js; rm adrum.zip)
(cd ECommerce-Angular && docker build -t appdynamics/ecommerce-angular .)

# Build Fault Injection UI container
echo; echo "Building ECommerce-FaultInjection..."
(cd ECommerce-FaultInjection && git clone https://github.com/Appdynamics/ECommerce-FaultInjectionUI.git)
(cd ECommerce-FaultInjection && docker build -t appdynamics/ecommerce-faultinjection .)

# Build DBWrapper container
echo rds-dbwrapper; echo "Build ECommerce-Dbwrapper..."
(cd ECommerce-Dbwrapper && git clone https://github.com/AppDynamics/docker-dbwrapper.git)
(cd ECommerce-Dbwrapper && docker build -t appdynamics/ecommerce-dbwrapper .)

# Build LoadGen container
echo; echo "Building ECommerce-Load..."
(cd ECommerce-Load && git clone -b FaultInjection https://github.com/Appdynamics/ECommerce-Load.git)
(cd ECommerce-Load && docker build -t appdynamics/ecommerce-load .)
