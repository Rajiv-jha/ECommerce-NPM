#! /bin/bash

# Generates Dockerfiles with machine/analytics agent installs

# Usage information
if [[ $1 == --help ]]
then
  echo "Usage: makeDockerfiles.sh
          -a Include standalone Analytics Agent
          -l Use local build option
          -t Machine Agent distribution [zip|rpm]"
  exit 0
fi

DOCKERFILE_BASE="Dockerfile.base"
ANALYTICS_AGENT="false"
LOCAL_BUILD="false"

while getopts "t:al" opt; do
  case $opt in
    a)
      ANALYTICS_AGENT=true
      ;;
    l)
      LOCAL_BUILD=true
      DOCKERFILE_BASE="Dockerfile.local.base"
      ;;
    t)
      MACHINE_AGENT_DISTRO=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

if [ "${MACHINE_AGENT_DISTRO}" != "zip" ] && [ "${MACHINE_AGENT_DISTRO}" != "rpm" ]; then
  echo "MACHINE_AGENT_DISTRO must be zip or rpm"
  exit
fi

if [[ "${LOCAL_BUILD}" == "true" ]]; then
  echo "Using local build base Dockerfile (Dockerfile.local.base)"
else
  echo "Using full build base Dockerfile (Dockerfile.base)"
fi

if [[ `uname -a | grep "Darwin"` ]]
then
  SED_OPTS=".bak"
fi

if [ ${MACHINE_AGENT_DISTRO} == "zip" ]
then
  echo "Using .zip version of the Machine Agent"
  (cd ECommerce-Tomcat; cp -f ${DOCKERFILE_BASE} Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.zip' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-Tomcat/Dockerfile"
  (cd ECommerce-FulfillmentClient; cp -f ${DOCKERFILE_BASE} Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.zip' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-FulfillmentClient/Dockerfile"
  (cd ECommerce-SurveyClient; cp -f ${DOCKERFILE_BASE} Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.zip' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-SurveyClient/Dockerfile"
  (cd ECommerce-AddressService; cp -f ${DOCKERFILE_BASE} Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.zip' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-Dbwrapper/Dockerfile"
  (cd ECommerce-LBR; cp -f ${DOCKERFILE_BASE} Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.zip' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-LBR/Dockerfile"

elif [ ${MACHINE_AGENT_DISTRO} == "rpm" ]
then
  echo "Using .rpm  version pf the Machine Agent"
  (cd ECommerce-Tomcat; cp -f ${DOCKERFILE_BASE} Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-Tomcat/Dockerfile"
  (cd ECommerce-FulfillmentClient; cp -f ${DOCKERFILE_BASE} Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-FulfillmentClient/Dockerfile"
  (cd ECommerce-SurveyClient; cp -f ${DOCKERFILE_BASE} Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-SurveyClient/Dockerfile"
  (cd ECommerce-AddressService; cp -f ${DOCKERFILE_BASE} Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-Dbwrapper/Dockerfile"
  (cd ECommerce-LBR; cp -f ${DOCKERFILE_BASE} Dockerfile; sed -i ${SED_OPTS} '/# Machine Agent Install/ r Dockerfile.include.rpm' Dockerfile; rm -f Dockerfile.bak)
  echo "Created ECommerce-LBR/Dockerfile"
fi

if [ ${ANALYTICS_AGENT} == "true" ]
then
  echo "Adding standalone Analytics Agent"
  (cd ECommerce-Tomcat; sed -i ${SED_OPTS} '/# Analytics Agent Install/ r Dockerfile.include.analytics-agent' Dockerfile; rm -f Dockerfile.bak)
  echo "Updated ECommerce-Tomcat/Dockerfile"
fi
