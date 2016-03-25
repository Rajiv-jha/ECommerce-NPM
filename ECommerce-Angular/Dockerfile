FROM appdynamics/ecommerce-java:oracle-java7

# set timezone to UTC
RUN mv /etc/localtime /etc/localtime.bak
RUN ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Environment vars: Tomcat
ENV CATALINA_HOME /tomcat

# Install Tomcat
COPY /apache-tomcat.tar.gz /apache-tomcat.tar.gz
RUN tar zxf /apache-tomcat.tar.gz \
    && rm apache-tomcat.tar.gz \
    && mv apache-tomcat* tomcat 
RUN cd ${CATALINA_HOME}/bin;chmod +x *.sh

ADD /AngularUI-1.0-SNAPSHOT.war ${CATALINA_HOME}/webapps/angular.war

ADD update-rum-key.sh /update-rum-key.sh
ADD adrum.js /adrum.js
ADD startup.sh /startup.sh
RUN chmod +x /update-rum-key.sh
RUN chmod +x /startup.sh

WORKDIR /

# Note: This command should not return or the container will exit
CMD "/startup.sh"

EXPOSE 80
EXPOSE 8080
EXPOSE 8009
