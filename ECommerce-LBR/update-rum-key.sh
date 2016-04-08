#!/bin/bash

while getopts "k:c:e:" opt; do
  case $opt in
    k) 
      APP_KEY=$OPTARG
      ;;
    c)
      EUM_COLLECTOR=$OPTARG
      ;;
    e)
      EXT_SOURCE=$OPTARG
      ;;
    ?)
      echo "Invalid option: $OPTARG"
      showUsage
      exit
      ;;
  esac
done

showUsage() {
  echo
  echo 'Usage: update-rum-key -k <EUM App Key>'
  echo '                     [-c <EUM Collecctor>]'
  echo '                     [-e <Location for adrum-ext.js>]'
  echo 'The EUM App Key is required: this is used to update mod_substitute'
  echo 'The EUM Collector address is optional: use this to override beaconUrlHttp in adrum.js'
  echo 'The IP address for adrum-ext.js is optional: use this to override adrumExtUrl in adrum.js'
  echo 'Example: update-rum-key -k AAA-BBB-CCC -c 11.22.33.44:9001 -e s3-us-west-2.amazonaws.com/adrum'
  echo
}

if [ -z ${APP_KEY+x} ]; then
  echo "Error: must specify EUM App Key"
  showUsage
  exit 1
else
  echo "Updating mod-substitute with EUM App Key: ${APP_KEY}"
  sed -i "s/'xx-xxx-xx'/'${APP_KEY}'/g" $HTTPD_24/conf.modules.d/02-appd.conf
fi

if [ ! -z ${EUM_COLLECTOR+x} ]; then
  echo "Updating adrum.js with beaconUrlHttp: ${EUM_COLLECTOR}"
  sed -i "s/col.eum-appdynamics.com/${EUM_COLLECTOR}/g" ${HTTPD_DOC_ROOT}/adrum.js
fi

if [ ! -z ${EXT_SOURCE+x} ]; then
  echo "Updating adrum.js with adrumExtUrl: ${EXT_SOURCE}"
  sed -i "s/cdn.appdynamics.com/${EXT_SOURCE//\//\\/}/g" ${HTTPD_DOC_ROOT}/adrum.js
fi

# Restart Apache to pick up changed config
/etc/init.d/httpd24-httpd stop
/etc/init.d/httpd24-httpd start
