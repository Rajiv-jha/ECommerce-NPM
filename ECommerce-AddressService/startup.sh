#!/bin/bash
source /env.sh

# This script should not return or the container will exit
# The last command called should execute in the foreground

# Start Machine Agent
# Start manually with: docker exec <container> /start-machine-agent.sh
# /start-machine-agent.sh

/start-appserver-agent.sh
