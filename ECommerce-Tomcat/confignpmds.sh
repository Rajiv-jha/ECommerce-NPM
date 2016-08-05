#!/bin/sh

#NPM DS support has been added

k=$(find /tomcat/appagent/ -maxdepth 1 -type d -name "ver*" | sed "s:^/tomcat/appagent/::")

unzip -q /npm-ds.zip -d /tomcat/appagent/$k/external-services/