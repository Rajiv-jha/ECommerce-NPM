Provides Apache Synapse ESB services for the Ecommerce-Java demo, based on [ecommerce-java](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-Java/Dockerhub.md).

To run: `docker run --rm -it --name synapse --link controller:controller --link fulfillment:fulfillment --link jms:jms appdynamics/ecommerce-synapse` and link from other docker images using `--link synapse:synapse`.
