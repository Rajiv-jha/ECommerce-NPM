FROM appdynamics/ecommerce-java:oracle-java7

RUN yum -y install firefox
RUN yum -y install Xvfb

# Gradle
RUN wget -N http://services.gradle.org/distributions/gradle-2.1-all.zip
RUN unzip gradle-2.1-all.zip -d /opt/
RUN rm gradle-2.1-all.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

# Git Checkout
ENV LOAD_GEN_HOME /ECommerce-Load
RUN git clone https://github.com/Appdynamics/ECommerce-Load.git
RUN cd /ECommerce-Load;gradle distZip;
ADD /load-generator.zip /ECommerce-Load/build/distributions/
RUN unzip ECommerce-Load/build/distributions/load-generator.zip -d /
RUN chmod +x $LOAD_GEN_HOME/bin/*
ADD env.sh /
ADD startup.sh /	
CMD ["/bin/bash","/startup.sh"]
