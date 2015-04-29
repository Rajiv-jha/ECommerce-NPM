FROM appdynamics/ecommerce-java:oracle-java7

# Centos 6 installs Apache 2.2 by default: we want 2.4
RUN useradd -U apache
RUN cd /etc/yum.repos.d/; wget http://repos.fedorapeople.org/repos/jkaluza/httpd24/epel-httpd24.repo
RUN yum -y install httpd24.x86_64
ENV HTTPD_24 /opt/rh/httpd24/root/etc/httpd
ENV APPDYNAMICS_SIM_ENABLED true

# Add mod_appdynamics 
#RUN echo 'SetEnv APPD_SDK_ENV_LOG_CONFIG_PATH /opt/appdynamics/appdynamics-sdk-native/conf/appdynamics_sdk_log4cxx.xml' >>  ${HTTPD_24}/conf.modules.d/00-base.conf
#RUN echo 'PassEnv APPD_SDK_ENV_LOG_CONFIG_PATH' >>  ${HTTPD_24}/conf.modules.d/00-base.conf
#RUN echo 'LoadModule appdynamics_module modules/mod_appdynamics.so' >>  ${HTTPD_24}/00-appd.conf
ADD appd.conf ${HTTPD_24}/

# TODO: Fix mod_appdynamics dependency on lib_curl3
#RUN ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl.so.3

# Add native SDK
	
ENV SDK_HOME /opt
ENV NATIVE_HOME ${SDK_HOME}/appdynamics-sdk-native
#RUN mkdir ${SDK_HOME}

ADD webserver_agent.tar.gz ${SDK_HOME}
ADD appdynamics_sdk.conf /etc/ld.so.conf.d/
RUN ldconfig;cd ${SDK_HOME} gunzip ${SDK_HOME}/webserver_agent.tar.gz;cd ${SDK_HOME} tar xf ${SDK_HOME}/webserver_agent.tar;chmod 777 ${NATIVE_HOME}/logs;chmod 744 ${NATIVE_HOME}/install.sh;
RUN ${NATIVE_HOME}/install.sh

# Add libappdynamics_native_sdk
RUN ln -s ${NATIVE_HOME}/sdk_lib/lib/libappdynamics_native_sdk.so /usr/lib64/libappdynamics_native_sdk.so;ln -s $NATIVE_HOME/WebServerAgent/Apache/libmod_appdynamics.so $HTTPD_24/modules/mod_appdynamics.so 

# ECommerce reverse proxy configuration
ADD ajp_proxy.conf ${HTTPD_24}/conf.d/

# Install Machine Agent
ENV MACHINE_AGENT_HOME /opt/appdynamics/machine-agent
ADD machineagent.rpm /
RUN rpm -i /machineagent.rpm;rm /machineagent.rpm
ADD controller-info.xml /


# Add utility scripts to /usr/local/bin
ADD tail-proxy-log /usr/local/bin/
ADD tail-access-log /usr/local/bin/
ADD tail-error-log /usr/local/bin/
RUN chmod 744 /usr/local/bin/tail-*

ADD env.sh $NATIVE_HOME/
ADD startup.sh $NATIVE_HOME/
RUN chmod 744 ${NATIVE_HOME}/env.sh;chmod 744 ${NATIVE_HOME}/startup.sh;chown -R apache:apache ${NATIVE_HOME};chmod 7777 -R ${NATIVE_HOME};

# Run startup script and tail Apache error log
CMD ${NATIVE_HOME}/startup.sh && tail -f ${HTTPD_24}/logs/error_log

EXPOSE 80
