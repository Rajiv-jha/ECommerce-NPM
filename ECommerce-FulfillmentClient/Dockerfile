FROM appdynamics/ecommerce-java:oracle-java7

# Install Gradle
RUN curl -O http://downloads.gradle.org/distributions/gradle-2.1-bin.zip
RUN unzip gradle-2.1-bin.zip -d /opt/
RUN rm gradle-2.1-bin.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin
ENV CLIENT_HOME /opt/fulfillment-client

# Copy ECommerce-Java project from build dir
ADD ECommerce-Java /ECommerce-Java

# Gradle build
RUN cd /ECommerce-Java;gradle uberJar;mkdir ${CLIENT_HOME};cp /ECommerce-Java/ECommerce-FulfillmentClient/build/libs/ECommerce-FulfillmentClient.jar ${CLIENT_HOME};rm -rf /ECommerce-Java;

# App Server Agent Install
ADD AppServerAgent.zip /
RUN unzip /AppServerAgent.zip -d ${CLIENT_HOME}/appagent;rm AppServerAgent.zip

# Machine Agent Install
# Install Machine Agent
ENV MACHINE_AGENT_HOME /opt/appdynamics/machine-agent
ADD machineagent.rpm /
RUN rpm -i /machineagent.rpm;rm /machineagent.rpm
ADD controller-info.xml /


# Analytics Agent config
ADD configAnalytics.sh /

# Startup scripts
ADD startup.sh /
ADD env.sh /

ADD start-machine-agent.sh /
ADD start-appserver-agent.sh /

RUN chmod +x /startup.sh;chmod +x /env.sh;chmod +x /start-machine-agent.sh;chmod +x /start-appserver-agent.sh;chmod +x /configAnalytics.sh

WORKDIR /
CMD ["/bin/bash","/startup.sh"]

EXPOSE 80	
EXPOSE 8080
EXPOSE 8009
