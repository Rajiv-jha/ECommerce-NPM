#! /bin/bash

# Build ECommerce demo containers from source, using latest agent bits from download.appdynamics.com
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
  wget --save-cookies cookies.txt  --post-data "username=$USER_NAME&password=$PASSWORD" --no-check-certificate https://login.appdynamics.com/sso/login/
  echo "Downloading AppServerAgent..."
  wget --load-cookies cookies.txt https://download.appdynamics.com/onpremise/public/latest/AppServerAgent.zip
  sleep 5
  echo "Downloading MachineAgent..."
  wget --load-cookies cookies.txt https://download.appdynamics.com/onpremise/public/latest/MachineAgent.zip
  sleep 5 
  #echo "Downloading DBAgent..."
  #wget --load-cookies cookies.txt https://download.appdynamics.com/onpremise/public/latest/DBAgent.zip
else
  echo "Username or Password missing"
fi

echo "Creating local docker images..."

# Pull Java base image from appdynamics docker repo
docker pull appdynamics/ecommerce-java:oracle-java7

# Build Tomcat containers using downloaded AppServer and Machine Agents
# Use docker build with --no-cache option to force latest git repo clone
cp AppServerAgent.zip ECommerce-Tomcat/AppServerAgent.zip
cp MachineAgent.zip ECommerce-Tomcat/MachineAgent.zip
(cd ECommerce-Tomcat && docker build --no-cache -t appdynamics/ecommerce-tomcat .)

# Build Synapse container using downloaded AppServer adn Machine Agents
cp AppServerAgent.zip ECommerce-Synapse/AppServerAgent.zip
cp MachineAgent.zip ECommerce-Synapse/MachineAgent.zip
(cd ECommerce-Synapse && docker build -t appdynamics/ecommerce-synapse .)

# Build DBAgent container using downloaded DBAgent
# cp DBAgent.zip ECommerce-DBAgent
# (cd ECommerce-DBAgent && docker build -t appdynamics/ecommerce-dbagent .)

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
rm -f AppServerAgent.zip MachineAgent.zip
(cd ECommerce-Tomcat && rm -f AppServerAgent.zip MachineAgent.zip)
(cd ECommerce-Synapse && rm -f AppServerAgent.zip MachineAgent.zip)

