# MySQL database and DB Agent
docker run --name db -e MYSQL_ROOT_PASSWORD=singcontroller -p 3306:3306 -d mysql
docker run --rm -it --name dbagent --link db:db appdynamics/ecommerce-dbagent

# ActiveMQ service
docker run --rm -it --name jms appdynamics/ecommerce-activemq

# Tomcat-based services
docker run --rm -it --name msg -e jms=true --link controller:controller --link db:db --link jms:jms appdynamics/ecommerce-tomcat
docker run --rm -it --name ws -e ws=true --link controller:controller --link db:db --link jms:jms appdynamics/ecommerce-tomcat
docker run --rm -it --name fulfillment -e web=true -e NODE_NAME=fulfillment -e APP_NAME=Fulfillment -e TIER_NAME=Fulfillment-Processor --link controller:controller --link db:db --link ws:ws --link jms:jms   appdynamics/ecommerce-tomcat
docker run --rm -it --name web -e web=true -e JVM_ROUTE=route1 --link controller:controller --link db:db --link ws:ws --link jms:jms appdynamics/ecommerce-tomcat
docker run --rm -it --name web1 -e web=true -e JVM_ROUTE=route2 --link controller:controller --link db:db --link ws:ws --link jms:jms appdynamics/ecommerce-tomcat

# Apache httpd LBR service
docker run --rm -it --name lbr --link web:web --link web1:web1 -p 80:80  appdynamics/ecommerce-lbr

# Apache Synapse ESB service
docker run -rm -it --name synapse --link controller:controller --link fulfillment:fulfillment --link jms:jms appdynamics/ecommerce-synapse

# Selenium load generator
docker run --rm -it --name load-gen --link lbr:lbr appdynamics/ecommerce-load

