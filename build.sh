#! /bin/bash

cleanUp() {
  rm -f cookies.txt
  rm -f index.html*
  rm -rf .agents
  (cd ECommerce-Tomcat && rm -f AppServerAgent.zip MachineAgent.zip)
  (cd ECommerce-Tomcat && rm -rf monitors)
  (cd ECommerce-Synapse && rm -f AppServerAgent.zip MachineAgent.zip)
  (cd ECommerce-DBAgent && rm -f dbagent.zip)

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
}

promptForAnalytics() {
  read -e -p "Enter Analytics Account Name: " ANALYTICS_ACCOUNT_NAME
  read -e -p "Enter Analytics Account Key: " ANALYTICS_ACCOUNT_KEY
}

promptForPortal() {
  echo "Please Sign In to download agent..."
  echo "Email ID/UserName: "
  read USER_NAME

  stty -echo
  echo "Password: "
  read PASSWORD
  stty echo
}

downloadAgents() {
  mkdir -p .agents

  wget --quiet --save-cookies cookies.txt  --post-data "username=$USER_NAME&password=$PASSWORD" --no-check-certificate https://login.appdynamics.com/sso/login/

  echo "Downloading AppServerAgent..."
  wget --quiet --load-cookies cookies.txt https://download.appdynamics.com/onpremise/public/latest/AppServerAgent.zip -O .agents/AppServerAgent.zip
  if [ $? -ne 0 ]; then
     cleanUp
     exit
  fi
  APP_SERVER_AGENT=".agents/AppServerAgent.zip"

  echo "Downloading MachineAgent..."
  wget --quiet --load-cookies cookies.txt https://download.appdynamics.com/onpremise/public/latest/MachineAgent.zip -O .agents/MachineAgent.zip
  if [ $? -ne 0 ]; then
     cleanUp
     exit
  fi
  MACHINE_AGENT=".agents/MachineAgent.zip"

  echo "Downloading DBAgent..."
  wget --quiet --load-cookies cookies.txt https://download.appdynamics.com/onpremise/public/latest/dbagent.zip -O .agents/dbagent.zip
  if [ $? -ne 0 ]; then
     cleanUp
     exit
  fi
  DB_AGENT=".agents/dbagent.zip"
}


# Usage information
if [[ $1 == *--help* ]]
then
  echo "Specify agent locations: build.sh -a <Path to App Server Agent> -m <Path to Machine Agent> -d <Path to Database Agent>"
  echo "Download from downloads.appdynamics.com: build.sh --download"
  echo "Prompt for agent locations: build.sh"
  exit
fi

# Prompt for location of App Server, Machine and Database Agents
if  [ $# -eq 0 ]
then   
  promptForAgents
  promptForAnalytics

else
  # Download from download.appdynamics.com
  if [[ $1 == *--download* ]]
  then
    promptForPortal

    if [ "$USER_NAME" != "" ] && [ "$PASSWORD" != "" ];
    then
      downloadAgents
    else
      echo "Username or Password missing"
      exit
    fi

    promptForAnalytics 

  else
    # Allow user to specify locations of App Server, Machine and Database Agents
    while getopts "a:m:d:n:k:" opt; do
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
fi

# Pull Java base image from appdynamics docker repo
docker pull appdynamics/ecommerce-java:oracle-java7

# Copy Agent zips to build dirs
cp ${APP_SERVER_AGENT} ECommerce-Tomcat/AppServerAgent.zip
cp ${APP_SERVER_AGENT} ECommerce-Synapse/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-Tomcat/MachineAgent.zip

if [ "$ANALYTICS_ACCOUNT_NAME" != "" ] && [ "$ANALYTICS_ACCOUNT_KEY" != "" ];
then
  # Enable Analytics 
  (cd ECommerce-Tomcat && unzip MachineAgent.zip monitors/analytics-agent/monitor.xml)
  (cd ECommerce-Tomcat && sed -i .bak "s/false/true/g" monitors/analytics-agent/monitor.xml)
  (cd ECommerce-Tomcat && zip MachineAgent.zip monitors/analytics-agent/monitor.xml)
fi

# Build Tomcat containers using downloaded AppServer and Machine Agents
# Use docker build with --no-cache option to force latest git repo clone
(cd ECommerce-Tomcat && docker build --no-cache -t appdynamics/ecommerce-tomcat .)

# Build Synapse container using downloaded AppServer and Machine Agents
# Use docker build with --no-cache option to force latest git repo clone
cp ECommerce-Tomcat/MachineAgent.zip ECommerce-Synapse/MachineAgent.zip
(cd ECommerce-Synapse && docker build --no-cache -t appdynamics/ecommerce-synapse .)

# Build DBAgent container using downloaded DBAgent
cp ${DB_AGENT} ECommerce-DBAgent/dbagent.zip
(cd ECommerce-DBAgent && docker build -t appdynamics/ecommerce-dbagent .)

# Build LoadGen container
# Use docker build with --no-cache option to force latest git repo clone
(cd ECommerce-Load && docker build --no-cache -t appdynamics/load .)

# Pull ActiveMQ, LBR and LoadGen containers from appdynamics public docker repo
docker pull appdynamics/ecommerce-activemq
docker pull appdynamics/ecommerce-lbr
docker pull appdynamics/ecommerce-oracle

echo "Local docker container images installed: "
echo "    appdynamics/ecommerce-java:oracle-java7"
echo "    appdynamics/ecommerce-tomcat"
echo "    appdynamics/ecommerce-synapse"
echo "    appdynamics/ecommerce-dbagent"
echo "    appdynamics/ecommerce-activemq"
echo "    appdynamics/ecommerce-lbr"
echo "    appdynamics/ecommerce-load"
echo "    appdynamics/ecommerce-oracle"

cleanUp

