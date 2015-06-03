#! /bin/bash

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
  (cd ECommerce-LBR; cp -f Dockerfile.base Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-LBR/Dockerfile"
fi
