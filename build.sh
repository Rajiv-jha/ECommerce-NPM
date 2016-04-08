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

# Version-independent agent names used by Dockerfiles 
ZIP_MACHINE_AGENT=MachineAgent.zip
RPM_MACHINE_AGENT=machineagent.rpm
WEB_SERVER_AGENT=webserver_agent.tar.gz
APP_SERVER_AGENT=AppServerAgent.zip
ANALYTICS_AGENT=AnalyticsAgent.zip
DB_AGENT=dbagent.zip
JS_AGENT=adrum.js
ECOMMERCE_WARS="appdynamicspilot.war appdynamicspilotjms.war cart.war"

cleanUp() {
  if [ -z ${PREPARE_ONLY} ]; then 
    # Delete agent and build artifacts from docker build dirs
    (cd ECommerce-Tomcat && rm -f ${APP_SERVER_AGENT} ${ZIP_MACHINE_AGENT} ${RPM_MACHINE_AGENT} ${ANALYTICS_AGENT} apache-tomcat.tar.gz ${ECOMMERCE_WARS})
    (cd ECommerce-Tomcat && rm -f build.gradle database.properties ojdbc6.jar oracle.sql schema.sql settings.gradle zips.sql)
    (cd ECommerce-FulfillmentClient && rm -f ${APP_SERVER_AGENT} ${ZIP_MACHINE_AGENT} ${RPM_MACHINE_AGENT} ECommerce-FulfillmentClient.jar)
    (cd ECommerce-Synapse && rm -f ${APP_SERVER_AGENT} ${ZIP_MACHINE_AGENT} ${RPM_MACHINE_AGENT})
    (cd ECommerce-LBR && rm -f ${ZIP_MACHINE_AGENT} ${RPM_MACHINE_AGENT} ${WEB_SERVER_AGENT} ${JS_AGENT})
    (cd ECommerce-DBAgent && rm -f ${DB_AGENT})
    (cd ECommerce-Angular && rm -f ${JS_AGENT} AngularUI-1.0-SNAPSHOT.war apache-tomcat.tar.gz)
    (cd ECommerce-FaultInjection && rm -rf ECommerce-FaultInjectionUI)
    (cd ECommerce-SurveyClient && rm -f AppServerAgent.zip ${MACHINE_AGENT} ECommerce-SurveyClient-1.0.jar)
    (cd ECommerce-AddressService && rm -rf AppServerAgent.zip ${MACHINE_AGENT} apache-tomcat.tar.gz rds-dbwrapper.war)
    (cd ECommerce-Load && rm -rf load-generator.zip)
  fi

  # Delete temp copy of machine agent distro
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
  read -e -p "Enter path to App Server Agent: " APP_SERVER_AGENT_INPUT
  read -e -p "Enter path to Machine Agent: " MACHINE_AGENT_INPUT
  read -e -p "Enter path to DB Agent: " DB_AGENT_INPUT
  read -e -p "Enter path to Web Server Agent: " WEB_AGENT_INPUT
  read -e -p "Enter path to Javascript Agent: " ADRUM_AGENT_INPUT
  read -e -p "Enter path to Analytics Agent: " ANALYTICS_AGENT_INPUT
  read -e -p "Enter path to Oracle JDK7: " ORACLE_JDK7
  read -e -p "Enter path to ECommerce source code projects: " LOCAL_BUILD_PATH
  read -e -p "Enter path to Tomcat tar.gz distribution: " LOCAL_TOMCAT
}

# Copy Agent zips to build dirs
copyAgents() {
  echo "Adding AppDynamics Agents: 
    ${APP_SERVER_AGENT_INPUT} 
    ${WEB_AGENT_INPUT} 
    ${DB_AGENT_INPUT}
    ${MACHINE_AGENT_INPUT}
    ${ADRUM_AGENT_INPUT}" 

  cp -f ${APP_SERVER_AGENT_INPUT} ECommerce-Tomcat/${APP_SERVER_AGENT}
  cp -f ${MACHINE_AGENT_INPUT} ECommerce-Tomcat/${MACHINE_AGENT}
  echo "Copied Agents for ECommerce-Tomcat"

  cp -f ${APP_SERVER_AGENT_INPUT} ECommerce-FulfillmentClient/${APP_SERVER_AGENT}
  cp -f ${MACHINE_AGENT_INPUT} ECommerce-FulfillmentClient/${MACHINE_AGENT}
  echo "Copied Agents for ECommerce-FulfillmentClient"

  cp -f ${APP_SERVER_AGENT_INPUT} ECommerce-Synapse/${APP_SERVER_AGENT}
  cp -f ${MACHINE_AGENT_INPUT} ECommerce-Synapse/${MACHINE_AGENT}
  echo "Copied Agents for ECommerce-Synapse"

  cp -f ${WEB_AGENT_INPUT} ECommerce-LBR/${WEB_SERVER_AGENT}
  cp -f ${ADRUM_AGENT_INPUT} ECommerce-LBR/${JS_AGENT}
  cp -f ${MACHINE_AGENT_INPUT} ECommerce-LBR/${MACHINE_AGENT}
  echo "Copied Agents for ECommerce-LBR"

  cp -f ${DB_AGENT_INPUT} ECommerce-DBAgent/${DB_AGENT}
  echo "Copied Agents for ECommerce-DBAgent"

  cp -f ${ADRUM_AGENT_INPUT} ECommerce-Angular/${JS_AGENT}
  echo "Copied Agents for ECommerce-Angular"

  cp -f ${APP_SERVER_AGENT_INPUT} ECommerce-SurveyClient/AppServerAgent.zip
  cp -f ${MACHINE_AGENT_INPUT} ECommerce-SurveyClient/${MACHINE_AGENT}
  echo "Copied Agents for ECommerce-SurveyClient"

  cp -f ${MACHINE_AGENT_INPUT} ECommerce-AddressService/${MACHINE_AGENT}
  cp -f ${APP_SERVER_AGENT_INPUT} ECommerce-AddressService/AppServerAgent.zip
  echo "Copied Agents for ECommerce-AddressService"
}

# Clone ECommerce source projects into docker build dirs
cloneProjects() {
  (cp ${LOCAL_TOMCAT} ECommerce-Tomcat/apache-tomcat.tar.gz)
  (cp ${LOCAL_TOMCAT} ECommerce-Angular/apache-tomcat.tar.gz) 
  (cp ${LOCAL_TOMCAT} ECommerce-AddressService/apache-tomcat.tar.gz) 
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/ECommerce-Web/build/libs/appdynamicspilot.war ECommerce-Tomcat/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/ECommerce-JMS/build/libs/appdynamicspilotjms.war ECommerce-Tomcat/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/ECommerce-WS/build/libs/cart.war ECommerce-Tomcat/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/ECommerce-Web/libs/ojdbc6.jar ECommerce-Tomcat/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/build.gradle ECommerce-Tomcat/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/settings.gradle ECommerce-Tomcat/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/database.properties ECommerce-Tomcat/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/schema.sql ECommerce-Tomcat/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/oracle.sql ECommerce-Tomcat/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/zips.sql ECommerce-Tomcat/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/ECommerce-FulfillmentClient/build/libs/ECommerce-FulfillmentClient.jar ECommerce-FulfillmentClient/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Angular/target/AngularUI-1.0-SNAPSHOT.war ECommerce-Angular/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Load/build/distributions/load-generator.zip ECommerce-Load/)
  (cp ${LOCAL_BUILD_PATH}/ECommerce-Java/ECommerce-SurveyClient/build/libs/ECommerce-SurveyClient-1.0.jar ECommerce-SurveyClient/)
  (cp ${LOCAL_BUILD_PATH}/docker-dbwrapper/build/libs/rds-dbwrapper.war ECommerce-AddressService/)
}

# Build Docker containers
buildContainers() {
  echo; echo "Building ECommerce-Tomcat..." 
  (cd ECommerce-Tomcat && docker build --no-cache -t appdynamics/ecommerce-tomcat .) || exit $?

  echo; echo "Building ECommerce-FulfillmentClient..."
  (cd ECommerce-FulfillmentClient && docker build --no-cache -t appdynamics/ecommerce-fulfillment-client .) || exit $?

  echo; echo "Building ECommerce-DBAgent..."
  (cd ECommerce-DBAgent && docker build --no-cache -t appdynamics/ecommerce-dbagent .) || exit $?

  echo; echo "Building ECommerce-LBR..."
  (cd ECommerce-LBR && docker build --no-cache -t appdynamics/ecommerce-lbr .) || exit $?

  echo; echo "Building ECommerce-Angular..."
  (cd ECommerce-Angular && docker build --no-cache -t appdynamics/ecommerce-angular .) || exit $?

  echo; echo "Building ECommerce-Load..."
  (cd ECommerce-Load && docker build --no-cache -t appdynamics/ecommerce-load .) || exit $?

  echo; echo "Building ECommerce-Customer Survey Client..."
  (cd ECommerce-SurveyClient && docker build --no-cache -t appdynamics/ecommerce-survey-client .) || exit $?

  echo; echo "Building ECommerce-AddressService..."
  (cd ECommerce-AddressService && docker build --no-cache -t appdynamics/ecommerce-dbwrapper .) || exit $?
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
          -j <Path to Oracle JDK7>
          -b <Path to ECommerce source projects>
          -t <Path to Tomcat distro>"
  echo "Prompt for agent locations: build.sh"
  exit 0
fi

# Prompt for location of App Server, Machine and Database Agents
if  [ $# -eq 0 ]
then
  promptForAgents

else
  # Allow user to specify locations of App Server, Machine and Database Agents
  while getopts "a:m:d:w:r:y:j:t:b:p" opt; do
    case $opt in
      a)
        APP_SERVER_AGENT_INPUT=$OPTARG
        if [ ! -e ${APP_SERVER_AGENT_INPUT} ]; then
          echo "Not found: ${APP_SERVER_AGENT_INPUT}"; exit 1
        fi
        ;;
      m)
        export MACHINE_AGENT_INPUT=$OPTARG
        if [ ! -e ${MACHINE_AGENT_INPUT} ]; then
          echo "Not found: ${MACHINE_AGENT_INPUT}"; exit 1
        fi
        ;;
      d)
        DB_AGENT_INPUT=$OPTARG
        if [ ! -e ${DB_AGENT_INPUT} ]; then
          echo "Not found: ${DB_AGENT_INPUT}"; exit 1
        fi
        ;;
      w)
        WEB_AGENT_INPUT=$OPTARG
        if [ ! -e ${WEB_AGENT_INPUT} ]; then
          echo "Not found: ${WEB_AGENT_INPUT}"; exit 1
        fi
        ;;
      r)
        ADRUM_AGENT_INPUT=$OPTARG
        if [ ! -e ${ADRUM_AGENT_INPUT} ]; then
          echo "Not found: ${ADRUM_AGENT_INPUT}"; exit 1
        fi
        ;;
      y)
        ANALYTICS_AGENT_INPUT=$OPTARG 
	if [ ! -e ${ANALYTICS_AGENT_INPUT} ]; then
          echo "Not found: ${ANALYTICS_AGENT_INPUT}"; exit 1        
        fi
        ;;
      j)
        ORACLE_JDK7=$OPTARG
        if [ ! -e ${ORACLE_JDK7} ]; then
          echo "Not found: ${ORACLE_JDK7}"; exit 1
        fi
        ;; 
      p)
        echo "Prepare build environment only - no docker builds"
        PREPARE_ONLY=true;
        ;;
      b)
        LOCAL_BUILD_PATH=$OPTARG
        echo "Using local ECommerce-Java project from: ${LOCAL_BUILD_PATH}/ECommerce-Java (gradle war uberjar)"
        echo "Using local ECommerce-Angular project from: ${LOCAL_BUILD_PATH}/ECommerce-Angular (mvn clean install)"
        echo "Using local ECommerce-Load project from: ${LOCAL_BUILD}/ECommerce-Load (gradle distZip)"
        echo "Using local docker-dbwrapper project from: ${LOCAL_BUILD}/docker-dbwrapper (gradle clean build)"
        LOCAL_BUILD=true;
        ;;
      t)
        LOCAL_TOMCAT=$OPTARG
        echo "Using local Tomcat archive: ${LOCAL_TOMCAT}"
        LOCAL_BUILD=true;
        ;;
      \?)
        echo "Invalid option: -$OPTARG"
        ;;
    esac
  done
fi

if [ -z ${APP_SERVER_AGENT_INPUT} ]; then
    echo "Error: App Server Agent is required"; exit 1
fi

if [ -z ${MACHINE_AGENT_INPUT} ]; then
    echo "Error: Machine Agent is required"; exit 1
fi

if [ -z ${DB_AGENT_INPUT} ]; then
    echo "Error: Database Agent is required"; exit 1
fi

if [ -z ${WEB_AGENT_INPUT} ]; then
    echo "Error: Web Server Agent is required"; exit 1
fi

if [ -z ${ADRUM_AGENT_INPUT} ]; then
    echo "Error: Javascript Agent is required"; exit 1
fi

# Re-build ecommerce-java base image with specified JDK7
if [ -z ${ORACLE_JDK7} ]
then
    echo "Using base image: appdynamics/ecommerce-java:oracle-java7"
    echo "Using base image: appdynamics/ecommerce-java:selenium for ECommerce-Load"
    echo "Using base image: appdynamics/ecommerce-java:apache24 for ECommerce-LBR"
    echo "Using base image: appdynamics/ecommerce-java:openssh for ECommerce-DBAgent"
else
    if [ ${ORACLE_JDK7: -4} == ".rpm" ]
    then
        echo "Building ECommerce-Java base image..."
        echo "Using JDK: ${ORACLE_JDK7}"
        cp -f ${ORACLE_JDK7} ECommerce-Java/jdk-linux-x64.rpm
        (cd ECommerce-Java; docker build --no-cache -t appdynamics/ecommerce-java:oracle-java7 .) || exit $?
        (cd ECommerce-Java; docker build --no-cache -f Dockerfile.selenium -t appdynamics/ecommerce-java:selenium .) || exit $?
        (cd ECommerce-Java; docker build --no-cache -f Dockerfile.apache24 -t appdynamics/ecommerce-java:apache24 .) || exit $?
        (cd ECommerce-Java; docker build --no-cache -f Dockerfile.openssh -t appdynamics/ecommerce-java:openssh .) || exit $?
        echo
    else
        echo "Error: Oracle JDK7 (jdk-7uXX-linux-x64.rpm) is required"; exit 1
    fi
fi

# If supplied, add standalone analytics agent to build
if [ -z ${ANALYTICS_AGENT_INPUT} ]
then
    echo "Skipping standalone Analytics Agent install"
else
    echo "Using standalone Analytics Agent"
    echo "  ${ANALYTICS_AGENT_INPUT}"
    cp -f ${ANALYTICS_AGENT_INPUT} ECommerce-Tomcat/${ANALYTICS_AGENT}
    
    # Add analytics agent when creating Dockerfile for machine agent
    DOCKERFILE_OPTIONS="-al"
fi

if [ ${MACHINE_AGENT_INPUT: -4} == ".zip" ]
then
    ./makeDockerfiles.sh -t zip ${DOCKERFILE_OPTIONS}
    cp -f ${MACHINE_AGENT_INPUT} MachineAgent.zip
    MACHINE_AGENT="MachineAgent.zip"        
elif [ ${MACHINE_AGENT_INPUT: -4} == ".rpm" ]
then
    ./makeDockerfiles.sh -t rpm ${DOCKERFILE_OPTIONS}
    cp -f ${MACHINE_AGENT_INPUT} machineagent.rpm
    MACHINE_AGENT="machineagent.rpm"
else
    echo "Machine agent file extension not recognized"; exit 1
fi

copyAgents

cloneProjects

# Skip build if -p flag (Prepare only) set
if [ "${PREPARE_ONLY}" = true ] ; then
    echo "Skipping build phase"
else
    buildContainers
fi
