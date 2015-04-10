FROM appdynamics/ecommerce-java:oracle-java7

RUN yum -y install firefox
RUN yum -y install Xvfb

# Gradle
RUN curl -O http://downloads.gradle.org/distributions/gradle-2.1-bin.zip
RUN unzip gradle-2.1-bin.zip -d /opt/
RUN rm gradle-2.1-bin.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

# Add ECommerce-Load project from build dir 
ADD ECommerce-Load /ECommerce-Load
ENV LOAD_GEN_HOME /ECommerce-Load
RUN cd /ECommerce-Load; gradle distZip
RUN unzip ECommerce-Load/build/distributions/load-generator.zip -d /
RUN chmod +x $LOAD_GEN_HOME/bin/*
ADD env.sh /
ADD startup.sh /	
CMD ["/bin/bash","/startup.sh"]
