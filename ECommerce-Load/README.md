Provides load generation services for the Ecommerce-Java demo, which is based on [ecommerce-java](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-Java/Dockerhub.md).

This container is intended to be run with two load-balanced ECommerce-Server nodes, using [ecommerce-lbr](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-LBR/Dockerhub.md) to load-balance across the two nodes.

To run: `docker run --rm -it --name=load-gen --link lbr:lbr appdynamics/ecommerce-load`, where `--link lbr:lbr` refers to the ECommerce-LBR load-balancer container, started with `--name lbr`.  

To run against a remote ECommerce application: `docker run --rm -it --name=load-gen -e TARGET_HOST=<host> -e TARGET_PORT=<port> appdynamics/ecommerce-load` where TARGET_HOST (default='lbr') and TARGET_PORT (default=80) identify the remote ECommerce host:port.

The following values can be set via docker environment variables:

1. `NUM_OF_USERS` (default: 5)
2. `RAMP_TIME` (default: 5)
3. `TIME_BETWEEN_RUNS` (default: 5000)
4. `TARGET_HOST` (default: lbr)
5. `TARGET_PORT` (default: 80)
6. `WAIT_TIME` (default: 1000)

For more details of how to run the ECommerce demo containers, see [ecommerce-tomcat](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-Tomcat/Dockerhub.md).
