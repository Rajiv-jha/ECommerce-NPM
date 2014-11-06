Provides load generation services for the Ecommerce-Java demo.  See [ECommerce-Load](https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-Load) for details of the image, which is based on [ecommerce-java](https://registry.hub.docker.com/u/appdynamics/ecommerce-java/).

This container is intended to be run with two load-balanced ECommerce-Server nodes, using [ecommerce-lbr](https://registry.hub.docker.com/u/appdynamics/ecommerce-lbr/) to load-balance across the two nodes.

To run: `docker run --rm -it --name=load-gen --link lbr:lbr appdynamics/ecommerce-load`, where `--link lbr:lbr` refers to the ECommerce-LBR load-balancer container, started with `--name lbr`.  

For more details of how to run the ECommerce demo containers, see [ecommerce-tomcat](https://registry.hub.docker.com/u/appdynamics/ecommerce-tomcat/).
