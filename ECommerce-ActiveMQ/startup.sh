#!/bin/bash
#export ACTIVEMQ_OPTS_MEMORY="-Xms512m -Xmx512m";
cd ${MQ_HOME};
bin/activemq start && tail -f data/activemq.log
