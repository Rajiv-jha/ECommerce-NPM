#!/bin/bash

sed -i "s/xx-xxx-xx/${1}/g" /tomcat/webapps/angular/index.html
sed -i "s/APP_KEY_NOT_SET/${1}/g" adrum.js
sed -i "s/col.eum-appdynamics.com/${2}/g" adrum.js

cp adrum.js /tomcat/webapps/angular/js/
