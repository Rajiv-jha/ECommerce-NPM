#! /bin/bash

# Usage information
if [[ $1 == *--help* ]]
then
  echo "Specify agent locations: build.sh -a <Path to App Server Agent> -m <Path to Machine Agent> -d <Path to Database Agent>"
  echo "Download from downloads.appdynamics.com: build.sh --download"
  echo "Prompt for agent locations: build.sh"
  exit
fi

# Download App Server, Machine and Database Agent from downloads.appdynamics.com
# Requires an AppDynamics portal login: prompt user for email/password
if [[ $1 == *--download* ]]
then
    # Requires an AppDynamics portal login to download AppServer, Machine and DB Agents

    echo "Please Sign In to download agent..."
    echo "Email ID/UserName: "
    read USER_NAME

    stty -echo
    echo "Password: "
    read PASSWORD
    stty echo

    if [ "$USER_NAME" != "" ] && [ "$PASSWORD" != "" ];
    then
        mkdir -p .agents

        wget --save-cookies cookies.txt  --post-data "username=$USER_NAME&password=$PASSWORD" --no-check-certificate https://login.appdynamics.com/sso/login/

        echo "Downloading AppServerAgent..."
        wget --load-cookies cookies.txt https://download.appdynamics.com/onpremise/public/latest/AppServerAgent.zip -O .agents/AppServerAgent.zip
        if [ $? -ne 0 ]; then
            exit 
        fi
        APP_SERVER_AGENT=".agents/AppServerAgent.zip"

        echo "Downloading MachineAgent..."
        wget --load-cookies cookies.txt https://download.appdynamics.com/onpremise/public/latest/MachineAgent.zip -O .agents/MachineAgent.zip
        if [ $? -ne 0 ]; then
            exit 
        fi
        MACHINE_AGENT=".agents/MachineAgent.zip"

        echo "Downloading DBAgent..."
        wget --load-cookies cookies.txt https://download.appdynamics.com/onpremise/public/latest/dbagent.zip -O .agents/dbagent.zip
        if [ $? -ne 0 ]; then
            exit 
        fi
        DB_AGENT=".agents/dbagent.zip"
    else
        echo "Username or Password missing"
    fi
fi

# Allow user to specify locations of App Server, Machine and Database Agents
while getopts "a:m:d:" opt; do
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
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done
          
# Prompt for location of App Server, Machine and Database Agents if called without arguments
if  [ $# -eq 0 ]
then   
    read -e -p "Enter path to App Server Agent: " APP_SERVER_AGENT
    read -e -p "Enter path to Machine Agent: " MACHINE_AGENT
    read -e -p "Enter path to DB Agent: " DB_AGENT
fi

# Pull Java base image from appdynamics docker repo
docker pull appdynamics/ecommerce-java:oracle-java7

# Build Tomcat containers using downloaded AppServer and Machine Agents
# Use docker build with --no-cache option to force latest git repo clone
cp ${APP_SERVER_AGENT} ECommerce-Tomcat/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-Tomcat/MachineAgent.zip
(cd ECommerce-Tomcat && docker build --no-cache -t appdynamics/ecommerce-tomcat .)

# Build Synapse container using downloaded AppServer and Machine Agents
cp ${APP_SERVER_AGENT} ECommerce-Synapse/AppServerAgent.zip
cp ${MACHINE_AGENT} ECommerce-Synapse/MachineAgent.zip
(cd ECommerce-Synapse && docker build -t appdynamics/ecommerce-synapse .)

# Build DBAgent container using downloaded DBAgent
cp ${DB_AGENT} ECommerce-DBAgent/dbagent.zip
(cd ECommerce-DBAgent && docker build -t appdynamics/ecommerce-dbagent .)

# Pull ActiveMQ, LBR and LoadGen containers from appdyanmics public docker repo
docker pull appdynamics/ecommerce-activemq
docker pull appdynamics/ecommerce-lbr
docker pull appdynamics/ecommerce-load

echo "Local docker container images installed: "
echo "    appdynamics/ecommerce-java:oracle-java7"
echo "    appdynamics/ecommerce-tomcat"
echo "    appdynamics/ecommerce-synapse"
echo "    appdynamics/ecommerce-dbagent"
echo "    appdynamics/ecommerce-activemq"
echo "    appdynamics/ecommerce-lbr"
echo "    appdynamics/ecommerce-load"

# Cleanup
rm -f cookies.txt
rm -f index.html*
(cd ECommerce-Tomcat && rm -f AppServerAgent.zip MachineAgent.zip)
(cd ECommerce-Synapse && rm -f AppServerAgent.zip MachineAgent.zip)
(cd ECommerce-DBAgent && rm -f dbagent.zip)
