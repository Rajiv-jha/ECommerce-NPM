FROM appdynamics/ecommerce-java:oracle-java7

# Install Gradle
RUN curl -O http://downloads.gradle.org/distributions/gradle-2.1-bin.zip
RUN unzip -q gradle-2.1-bin.zip -d /opt/
RUN rm gradle-2.1-bin.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin
ENV CLIENT_HOME /opt/survey-client

# Copy ECommerce-Java project from build dir
ADD ECommerce-Java /ECommerce-Java

# Gradle build
RUN cd /ECommerce-Java; gradle uberJar; mkdir ${CLIENT_HOME}; cp /ECommerce-Java/ECommerce-SurveyClient/build/libs/ECommerce-SurveyClient-1.0.jar ${CLIENT_HOME}; rm -rf /ECommerce-Java;

# App Server Agent Install
ADD AppServerAgent.zip /
RUN unzip -q /AppServerAgent.zip -d ${CLIENT_HOME}/appagent;rm AppServerAgent.zip

# (Placeholder - build script will update with zip/rpm directives)
# Machine Agent Install
# Zip Machine Agent Install
ENV MACHINE_AGENT_HOME /machine-agent
ADD MachineAgent.zip /
RUN unzip -q /MachineAgent.zip -d ${MACHINE_AGENT_HOME}
RUN rm MachineAgent.zip
ADD controller-info.xml /

# Analytics Agent config
ADD configAnalytics.sh /

# Startup scripts
ADD startup.sh /
ADD env.sh /

ADD start-machine-agent.sh /
ADD start-appserver-agent.sh /

RUN chmod +x /startup.sh
RUN chmod +x /env.sh
RUN chmod +x /start-machine-agent.sh
RUN chmod +x /start-appserver-agent.sh
RUN chmod +x /configAnalytics.sh

WORKDIR /
CMD ["/bin/bash","/startup.sh"]

EXPOSE 80	
EXPOSE 8080
EXPOSE 8009
