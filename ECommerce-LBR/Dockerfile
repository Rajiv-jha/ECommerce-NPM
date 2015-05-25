FROM appdynamics/ecommerce-java:oracle-java7

# Centos 6 installs Apache 2.2 by default: we want 2.4
RUN useradd -U apache
RUN cd /etc/yum.repos.d/; wget http://repos.fedorapeople.org/repos/jkaluza/httpd24/epel-httpd24.repo
RUN yum -y install httpd24.x86_64
ENV HTTPD_24 /opt/rh/httpd24/root/etc/httpd
ENV APPDYNAMICS_SIM_ENABLED true

# Environment settings for startup scripts
ADD env.sh /
RUN chmod +x /env.sh

# Add mod_appdynamics configuration file
ADD appd.conf ${HTTPD_24}/

# Add native SDK
ENV SDK_HOME /opt
ENV NATIVE_HOME ${SDK_HOME}/appdynamics-sdk-native

ADD webserver_agent.tar.gz ${SDK_HOME}
ADD appdynamics_sdk.conf /etc/ld.so.conf.d/
RUN ldconfig;cd ${SDK_HOME} gunzip ${SDK_HOME}/webserver_agent.tar.gz;cd ${SDK_HOME} tar xf ${SDK_HOME}/webserver_agent.tar;chmod 777 ${NATIVE_HOME}/logs;chmod 744 ${NATIVE_HOME}/install.sh;
RUN ${NATIVE_HOME}/install.sh

# Add libappdynamics_native_sdk
RUN ln -s ${NATIVE_HOME}/sdk_lib/lib/libappdynamics_native_sdk.so /usr/lib64/libappdynamics_native_sdk.so
RUN ln -s ${NATIVE_HOME}/WebServerAgent/Apache/libmod_appdynamics.so $HTTPD_24/modules/mod_appdynamics.so 

# ECommerce reverse proxy configuration
ADD ajp_proxy.conf ${HTTPD_24}/conf.d/

# (Placeholder - build script will update with zip/rpm directives)
# Machine Agent Install

# Start the Machine Agent
ADD start-machine-agent.sh /
RUN chmod 744 /start-machine-agent.sh

# Add utility scripts to /usr/local/bin
ADD tail-proxy-log /usr/local/bin/
ADD tail-access-log /usr/local/bin/
ADD tail-error-log /usr/local/bin/
RUN chmod 744 /usr/local/bin/tail-*

ADD startup.sh $NATIVE_HOME/
RUN chmod 744 ${NATIVE_HOME}/startup.sh
RUN chown -R apache:apache ${NATIVE_HOME}
RUN chmod 7777 -R ${NATIVE_HOME}

ADD start-machine-agent.sh $MACHINE_AGENT_HOME/
RUN chmod 744 ${MACHINE_AGENT_HOME}/start-machine-agent.sh

# Configure Log Analytics
ADD configAnalytics.sh /
RUN chmod +x /configAnalytics.sh
ADD ecommerce-lbr-httpserver-error-log.job ${MACHINE_AGENT_HOME}/monitors/analytics-agent/conf/job/
ADD ecommerce-lbr-httpserver-access-log.job ${MACHINE_AGENT_HOME}/monitors/analytics-agent/conf/job/

# Run startup script and tail Apache error log
CMD ${NATIVE_HOME}/startup.sh && tail -f ${HTTPD_24}/logs/error_log

EXPOSE 80
