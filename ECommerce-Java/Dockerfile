FROM centos:centos6

RUN yum -y install unzip
RUN yum -y install tar
RUN yum -y install ntp

# Install Gradle
RUN curl -O http://downloads.gradle.org/distributions/gradle-2.1-bin.zip
RUN unzip gradle-2.1-bin.zip -d /opt/
RUN rm gradle-2.1-bin.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

# Install Oracle JDK
ADD jdk-linux-x64.rpm /
RUN rpm -Uvh /jdk-linux-x64.rpm

RUN rm jdk-linux-x64.rpm
ENV JAVA_HOME /usr/java/default
ENV APPDYNAMICS_SIM_ENABLED true
ENV PATH $PATH:$JAVA_HOME/bin
