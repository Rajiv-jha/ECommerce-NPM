# install Java7 from http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm
FROM appdynamics/ecommerce-java:oracle-java7

# set timezone to UTC
RUN mv /etc/localtime /etc/localtime.bak
RUN ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime

RUN yum -y install unzip
RUN yum -y install openssh-server openssh-clients

#Agent Install
ENV AGENT_HOME /dbagent
ADD dbagent.zip /
RUN unzip -q /dbagent.zip -d ${AGENT_HOME}
RUN rm dbagent.zip
ADD controller-info.xml /

ADD env.sh /
ADD startup.sh /
RUN chmod +x /startup.sh
WORKDIR /
CMD ["/bin/bash","/startup.sh"]
