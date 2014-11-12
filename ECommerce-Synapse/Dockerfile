FROM appdynamics/ecommerce-java:oracle-java7


ENV SYNAPSE_HOME /synapse-2.1.0


RUN curl http://mirror.olnevhost.net/pub/apache//synapse/2.1.0/synapse-2.1.0-bin.tar.gz | tar -xz

EXPOSE 8280
EXPOSE 1099
EXPOSE 8243

ADD startup.sh /

RUN chmod +x /startup.sh

CMD /startup.sh
