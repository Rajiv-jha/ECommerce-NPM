FROM appdynamics/ecommerce-java:oracle-java7

# Centos 6 installs Apache 2.2 by default: we want 2.4
RUN cd /etc/yum.repos.d/; wget http://repos.fedorapeople.org/repos/jkaluza/httpd24/epel-httpd24.repo
RUN yum -y install httpd24.x86_64
ENV HTTPD_24 /opt/rh/httpd24/root/etc/httpd

# Add mod_appdynamics 
RUN echo 'LoadModule appdynamics_module modules/mod_appdynamics.so' >>  ${HTTPD_24}/conf.modules.d/00-base.conf
ADD libmod_appdynamics.so ${HTTPD_24}/modules/mod_appdynamics.so
ADD appd.conf ${HTTPD_24}/conf.d/

# TODO: Fix mod_appdynamics dependency on lib_curl3
RUN ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl.so.3

# Add native SDK
RUN mkdir /opt/appdynamics
ADD appdynamics-sdk-native.tar.bz2 /opt/appdynamics/
RUN chmod 777 /opt/appdynamics/appdynamics-sdk-native/logs
RUN chmod 744 /opt/appdynamics/appdynamics-sdk-native/install.sh
RUN /opt/appdynamics/appdynamics-sdk-native/install.sh

# Add libappdynamics_native_sdk
RUN ln -s /opt/appdynamics/appdynamics-sdk-native/sdk_lib/lib/libappdynamics_native_sdk.so /usr/lib64/libappdynamics_native_sdk.so

# ECommerce reverse proxy configuration
ADD ajp_proxy.conf ${HTTPD_24}/conf.d/

# Install Machine Agent
ENV MACHINE_AGENT_HOME /opt/appdynamics/machine_agent
ADD MachineAgent.zip /
RUN unzip /MachineAgent.zip -d ${MACHINE_AGENT_HOME}
RUN rm MachineAgent.zip

# Add utility scripts to /usr/local/bin
ADD tail-proxy-log /usr/local/bin/
ADD tail-access-log /usr/local/bin/
ADD tail-error-log /usr/local/bin/
RUN chmod 744 /usr/local/bin/tail-*

# Set Controller, Port, App, Tier and Node via env vars
ADD env.sh /opt/appdynamics/
ADD start.sh /opt/appdynamics/
RUN chmod 744 /opt/appdynamics/env.sh
RUN chmod 744 /opt/appdynamics/start.sh

# Run startup script and tail Apache error log
CMD /opt/appdynamics/start.sh && tail -f ${HTTPD_24}/logs/error_log

EXPOSE 80
