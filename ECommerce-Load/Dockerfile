# install Java7 from http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm
FROM appdynamics/ecommerce-java:oracle-java7

RUN yum -y install firefox
RUN yum -y install Xvfb

#GRADLE
RUN wget -N http://services.gradle.org/distributions/gradle-2.1-all.zip
RUN unzip gradle-2.1-all.zip -d /opt/
RUN rm gradle-2.1-all.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

# GIT Checkout
ENV LOAD_GEN_HOME /ECommerce-Load
RUN git clone https://github.com/Appdynamics/ECommerce-Load.git
RUN cd /ECommerce-Load;gradle distZip;
RUN unzip ECommerce-Load/build/distributions/load-generator.zip -d /
RUN chmod +x $LOAD_GEN_HOME/bin/*
ADD startup.sh /	
CMD ["/bin/bash","/startup.sh"]

