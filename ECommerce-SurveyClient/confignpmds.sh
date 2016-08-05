#!/bin/sh

#NPM DS support has been added

k=$(find /opt/survey-client/appagent/ -maxdepth 1 -type d -name "ver*" | sed "s:^/opt/survey-client/appagent/::")

echo $k

unzip -q /npm-ds.zip -d /opt/survey-client/appagent/$k/external-services/