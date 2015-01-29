Provides load generation services for the Ecommerce-Java demo, which is based on [ecommerce-java](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-Java/Dockerhub.md).

This container is intended to be run with two load-balanced ECommerce-Server nodes, using [ecommerce-lbr](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-LBR/Dockerhub.md) to load-balance across the two nodes.

To run: `docker run --rm -it --name=load-gen --link lbr:lbr appdynamics/ecommerce-load`, where `--link lbr:lbr` refers to the ECommerce-LBR load-balancer container, started with `--name lbr`.  

For more details of how to run the ECommerce demo containers, see [ecommerce-tomcat](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-Tomcat/Dockerhub.md).
