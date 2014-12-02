# install Java7 from http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm
FROM appdynamics/ecommerce-java:oracle-java7

#GRADLE
RUN wget -N http://services.gradle.org/distributions/gradle-2.1-bin.zip
RUN unzip gradle-2.1-bin.zip -d /opt/
RUN rm gradle-2.1-bin.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

# GIT Checkout
RUN git clone https://github.com/Appdynamics/ECommerce-Java.git

#Gradle
RUN cd /ECommerce-Java;gradle war

#TOMCAT
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.14
ENV CATALINA_HOME /tomcat


# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

RUN cd ${CATALINA_HOME}/bin;chmod +x *.sh

#Agent Install
ADD AppServerAgent.zip /
RUN unzip /AppServerAgent.zip -d ${CATALINA_HOME}/appagent
RUN rm AppServerAgent.zip


#Machine Agent Install
ENV MACHINE_AGENT_HOME /machine_agent
ADD MachineAgent.zip /
ADD monitor.xml /
ADD analytics-agent.properties /
RUN unzip /MachineAgent.zip -d ${MACHINE_AGENT_HOME}
RUN mv /monitor.xml ${MACHINE_AGENT_HOME}/monitors/analytics-agent/
RUN mv /analytics-agent.properties ${MACHINE_AGENT_HOME}/monitors/analytics-agent/conf
RUN rm MachineAgent.zip

ADD startup.sh /
ADD env.sh /
ADD start-machine-agent.sh /
RUN chmod +x /startup.sh
RUN chmod +x /start-machine-agent.sh
RUN chmod +x /env.sh
WORKDIR /
CMD ["/bin/bash","/startup.sh"]

EXPOSE 80	
EXPOSE 8080
