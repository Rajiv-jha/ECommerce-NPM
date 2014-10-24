!#/bin/bash
nohup Xvfb :10 -ac &
export DISPLAY=:10;
$LOAD_GEN_HOME/bin/ECommerce-Load 5  5 5000 web 80 1000