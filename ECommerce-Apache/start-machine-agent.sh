echo "Starting Machine Agent..."
source /opt/appdynamics/env.sh
nohup java ${AGENT_OPTS} -jar ${MACHINE_AGENT_HOME}/machineagent.jar  > ${MACHINE_AGENT_HOME}/machine_agent.log &
