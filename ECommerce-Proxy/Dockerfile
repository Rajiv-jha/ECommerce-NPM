FROM centos:centos6

RUN yum -y install httpd

ADD rev_proxy.conf /etc/httpd/conf.d/


WORKDIR /
CMD apachectl start && tail -f /etc/httpd/logs/error_log

EXPOSE 80	
