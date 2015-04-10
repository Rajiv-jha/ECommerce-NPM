FROM centos:centos6

RUN yum -y install unzip
RUN yum -y install tar

# Install Oracle JDK
RUN curl -j -k -L -H "Cookie:oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u71-b13/jdk-7u71-linux-x64.rpm -o jdk-linux-x64.rpm
RUN rpm -Uvh jdk-linux-x64.rpm

RUN rm jdk-linux-x64.rpm
ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin
