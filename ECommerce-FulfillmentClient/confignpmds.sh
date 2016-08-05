#!/bin/sh

#NPM DS support has been added

k=$(find /opt/fulfillment-client/appagent/ -maxdepth 1 -type d -name "ver*" | sed "s:^/opt/fulfillment-client/appagent/::")

echo $k

unzip -q /npm-ds.zip -d /opt/fulfillment-client/appagent/$k/external-services/
