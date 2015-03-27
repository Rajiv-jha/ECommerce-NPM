FROM appdynamics/ecommerce-java:oracle-java7

# Centos 6 installs Apache 2.2 by default: we want 2.4
RUN useradd -U apache
RUN cd /etc/yum.repos.d/; wget http://repos.fedorapeople.org/repos/jkaluza/httpd24/epel-httpd24.repo
RUN yum -y install httpd24.x86_64
ENV HTTPD_24 /opt/rh/httpd24/root/etc/httpd

# Add mod_appdynamics 
RUN echo 'SetEnv APPD_SDK_ENV_LOG_CONFIG_PATH /opt/appdynamics/appdynamics-sdk-native/conf/appdynamics_sdk_log4cxx.xml' >>  ${HTTPD_24}/conf.modules.d/00-base.conf
RUN echo 'PassEnv APPD_SDK_ENV_LOG_CONFIG_PATH' >>  ${HTTPD_24}/conf.modules.d/00-base.conf
RUN echo 'LoadModule appdynamics_module modules/mod_appdynamics.so' >>  ${HTTPD_24}/conf.modules.d/00-base.conf
ADD libmod_appdynamics.so ${HTTPD_24}/modules/mod_appdynamics.so
ADD appd.conf ${HTTPD_24}/conf.d/

# TODO: Fix mod_appdynamics dependency on lib_curl3
#RUN ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl.so.3

# Add native SDK

ENV SDK_HOME /opt/appdynamics
ENV NATIVE_HOME ${SDK_HOME}/appdynamics-sdk-native
RUN mkdir ${SDK_HOME}

ADD appdynamics-sdk-native.tar.bz2 ${SDK_HOME}
RUN chmod 777 ${NATIVE_HOME}/logs;chmod 744 ${NATIVE_HOME}/install.sh;
RUN ${NATIVE_HOME}/install.sh

# Add libappdynamics_native_sdk
RUN ln -s /opt/appdynamics/appdynamics-sdk-native/sdk_lib/lib/libappdynamics_native_sdk.so /usr/lib64/libappdynamics_native_sdk.so

# ECommerce reverse proxy configuration
ADD ajp_proxy.conf ${HTTPD_24}/conf.d/

# Install Machine Agent
# ENV MACHINE_AGENT_HOME /opt/appdynamics/machine_agent
# ADD MachineAgent.zip /
# RUN unzip /MachineAgent.zip -d ${MACHINE_AGENT_HOME}
# RUN rm MachineAgent.zip

# Add utility scripts to /usr/local/bin
ADD tail-proxy-log /usr/local/bin/
ADD tail-access-log /usr/local/bin/
ADD tail-error-log /usr/local/bin/
RUN chmod 744 /usr/local/bin/tail-*

# Set Controller, Port, App, Tier and Node via env vars
ADD env.sh /opt/appdynamics/
ADD startup.sh /opt/appdynamics/
RUN chmod 744 /opt/appdynamics/env.sh;chmod 744 /opt/appdynamics/startup.sh;chown -R apache:apache /opt/appdynamics;chmod 7777 -R /opt/appdynamics;

# Run startup script and tail Apache error log
CMD /opt/appdynamics/startup.sh && tail -f ${HTTPD_24}/logs/error_log

EXPOSE 80
