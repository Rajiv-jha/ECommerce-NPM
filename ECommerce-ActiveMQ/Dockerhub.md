Provides ActiveMQ JMS services for the Ecommerce-Java demo, based on [ecommerce-java](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-Java/Dockerhub.md).

To run: `docker run --rm -it --name jms appdynamics/ecommerce-activemq` and link from other docker images using `--link jms:jms`.  See [ecommerce-tomcat](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-Tomcat/Dockerhub.md) for examples.
