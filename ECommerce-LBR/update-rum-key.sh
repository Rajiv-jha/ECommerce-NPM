#!/bin/bash
sed -i "s/'xx-xxx-xx'/'${1}'/g" $HTTPD_24/conf.modules.d/02-appd.conf

