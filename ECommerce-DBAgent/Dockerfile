# install Java7 from http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm
FROM appdynamics/ecommerce-java:oracle-java7

RUN yum -y install unzip

#Agent Install
ENV AGENT_HOME /dbagent
ADD dbagent.zip /
RUN unzip -q /dbagent.zip -d ${AGENT_HOME}
RUN rm dbagent.zip

ADD startup.sh /
RUN chmod +x /startup.sh
WORKDIR /
CMD ["/bin/bash","/startup.sh"]
