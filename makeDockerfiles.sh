#! /bin/bash

# Generates Dockerfiles with machine/analytics agent installs
#   makeDockerfiles.sh zip|rpm = (zip/rpm version of) machine agent only
#   makeDockerfiles.sh zip|rpm analytics =  machine agent plus analytics-agent

if [[ `uname -a | grep "Darwin"` ]]
then
  SED_OPTS=".bak"
fi

if [ $1 == "zip" ]
then
  echo "Using .zip version of the Machine Agent"
  (cd ECommerce-Tomcat; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.zip' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-Tomcat/Dockerfile"
  (cd ECommerce-FulfillmentClient; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.zip' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-FulfillmentClient/Dockerfile"
  (cd ECommerce-Synapse; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.zip' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-Synapse/Dockerfile"
  (cd ECommerce-AddressService; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.zip' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-Dbwrapper/Dockerfile"
  (cd ECommerce-SurveyClient; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.zip' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-SurveyClient/Dockerfile"
  (cd ECommerce-LBR; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.zip' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-LBR/Dockerfile"

elif [ $1 == "rpm" ]
then
  echo "Using .rpm  version pf the Machine Agent"
  (cd ECommerce-Tomcat; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-Tomcat/Dockerfile"
  (cd ECommerce-FulfillmentClient; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-FulfillmentClient/Dockerfile"
  (cd ECommerce-Synapse; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-Synapse/Dockerfile"
  (cd ECommerce-SurveyClient; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-SurveyClient/Dockerfile"
  (cd ECommerce-Dbwrapper; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-Dbwrapper/Dockerfile"
  (cd ECommerce-LBR; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-LBR/Dockerfile"
fi

if [ $# -eq 2 ] && [ $2 == "analytics" ]
then
  echo "Adding standalone Analytics Agent"
  (cd ECommerce-Tomcat; sed -i ${SED_OPTS} '/# Analytics Agent Install/ r Dockerfile.include.analytics-agent' Dockerfile; rm -f Dockerfile.bak)
  echo "Updated ECommerce-Tomcat/Dockerfile"
fi
