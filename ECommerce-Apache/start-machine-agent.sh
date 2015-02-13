echo "Starting Machine Agent..."
source /opt/appdynamics/env.sh
echo java ${AGENT_OPTS} -jar ${MACHINE_AGENT_HOME}/machineagent.jar
nohup java ${AGENT_OPTS} -jar ${MACHINE_AGENT_HOME}/machineagent.jar  > ${MACHINE_AGENT_HOME}/machine_agent.log 2>&1 &
