FROM centos:centos6

RUN yum -y install unzip
RUN yum -y install tar

# Install Oracle JDK
ADD jdk-linux-x64.rpm /
RUN rpm -Uvh /jdk-linux-x64.rpm
RUN yum install ntp

RUN rm jdk-linux-x64.rpm
ENV JAVA_HOME /usr/java/default
ENV APPDYNAMICS_SIM_ENABLED true
ENV PATH $PATH:$JAVA_HOME/bin
