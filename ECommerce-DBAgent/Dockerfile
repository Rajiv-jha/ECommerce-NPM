FROM appdynamics/ecommerce-java:openssh

# set timezone to UTC
RUN mv /etc/localtime /etc/localtime.bak
RUN ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime

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
