FROM appdynamics/ecommerce-java:selenium

# set timezone to UTC
RUN mv /etc/localtime /etc/localtime.bak
RUN ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime

ENV LOAD_GEN_HOME /ECommerce-Load
COPY load-generator.zip /
RUN unzip /load-generator.zip -d /

RUN chmod +x $LOAD_GEN_HOME/bin/*

ADD env.sh /
ADD startup.sh /
CMD ["/bin/bash","/startup.sh"]
