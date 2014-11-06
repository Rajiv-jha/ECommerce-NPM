Provides ActiveMQ JMS services for the Ecommerce-Java demo.  See [ECommerce-ActiveMQ](https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-ActiveMQ) for details of the image, which is based on [ecommerce-java](https://registry.hub.docker.com/u/appdynamics/ecommerce-java/).

To run: `docker run --rm -it --name jms appdynamics/ecommerce-activemq` and link from other docker images using `--link jms:jms`.  See [ecommerce-tomcat](https://registry.hub.docker.com/u/appdynamics/ecommerce-tomcat/) for examples.
