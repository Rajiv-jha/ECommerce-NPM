# install Java7 from http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm
FROM centos:centos6

RUN yum -y install httpd

ADD ajp_proxy.conf /etc/httpd/conf.d/


WORKDIR /
CMD apachectl start && tail -f /etc/httpd/logs/access_log

EXPOSE 80	
