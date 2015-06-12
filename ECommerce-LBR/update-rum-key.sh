#!/bin/bash

sed -i "s/'xx-xxx-xx'/'${1}'/g" $HTTPD_24/conf.modules.d/02-appd.conf
sed -i "s/col.eum-appdynamics.com/${2}/g" ${HTTPD_DOC_ROOT}/adrum.js
/etc/init.d/httpd24-httpd stop
/etc/init.d/httpd24-httpd start