FROM appdynamics/ecommerce-java:oracle-java7

# set timezone to UTC
RUN mv /etc/localtime /etc/localtime.bak
RUN ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime

ENV MQ_HOME /apache-activemq-5.9.0
#active mq 5.10
RUN curl http://archive.apache.org/dist/activemq/apache-activemq/5.9.0/apache-activemq-5.9.0-bin.tar.gz | tar -xz

EXPOSE 61616

ADD startup.sh /

RUN chmod +x /startup.sh

CMD ["/bin/bash","/startup.sh"]
