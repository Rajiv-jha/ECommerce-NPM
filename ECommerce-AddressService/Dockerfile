#!/bin/bash
FROM appdynamics/ecommerce-java:oracle-java7

# Install packages
RUN yum -y install unzip git curl

# Install Gradle
RUN curl -O http://downloads.gradle.org/distributions/gradle-2.1-bin.zip
RUN unzip gradle-2.1-bin.zip -d /opt/
RUN rm gradle-2.1-bin.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

#TOMCAT
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.14
ENV CATALINA_HOME /tomcat

#INSTALL TOMCAT
RUN curl -O -k https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz \
    && curl -O -k https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 \
    && md5sum apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 \
    && tar zxf apache-tomcat-*.tar.gz \
    && rm apache-tomcat-*.tar.gz \
    && mv apache-tomcat-${TOMCAT_MINOR_VERSION} tomcat
RUN cd ${CATALINA_HOME}/bin;chmod +x *.sh

ADD docker-dbwrapper /docker-dbwrapper
RUN cd /docker-dbwrapper; gradle clean build; mv build/libs/rds-dbwrapper.war ${CATALINA_HOME}/webapps/

# App Server Agent Install
ADD AppServerAgent.zip /
RUN unzip -q /AppServerAgent.zip -d ${CATALINA_HOME}/appagent;rm /AppServerAgent.zip

# (Placeholder - build script will update with zip/rpm directives)
# Machine Agent Install
# Zip Machine Agent Install
ENV MACHINE_AGENT_HOME /machine-agent
ADD MachineAgent.zip /
RUN unzip -q /MachineAgent.zip -d ${MACHINE_AGENT_HOME}
RUN rm MachineAgent.zip

# Analytics Agent config
ADD configAnalytics.sh /

# Startup scripts
ADD env.sh /

ADD start-machine-agent.sh /
ADD start-appserver-agent.sh /

RUN chmod +x /env.sh
RUN chmod +x /start-machine-agent.sh
RUN chmod +x /start-appserver-agent.sh
RUN chmod +x /configAnalytics.sh

RUN mkdir /tmp/logs
RUN chmod +x /tmp/logs

ADD startup.sh /
RUN chmod +x /startup.sh

WORKDIR /
CMD /startup.sh && tail -f /var/log/dmesg

#Exposing ports
EXPOSE 80
EXPOSE 8080
EXPOSE 8090
