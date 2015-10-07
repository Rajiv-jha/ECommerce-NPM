Provides load generation services for the Ecommerce-Java demo, which is based on [ecommerce-java](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-Java/Dockerhub.md).

This container is intended to be run with two load-balanced ECommerce-Server nodes, using [ecommerce-lbr](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-LBR/Dockerhub.md) to load-balance across the two nodes.

To run: `docker run --name=load-gen --link lbr:lbr --link angular:angular -d appdynamics/ecommerce-load:$VERSION`, where `--link lbr:lbr` refers to the ECommerce-LBR load-balancer container, started with `--name lbr` and `--link langular:angular` refers to the ECommerce-Angular Angular UI container, started with `--name angular` and `$VERSION` refers to tagged version.  

To run against a remote ECommerce application: `docker run --rm -it --name=load-gen --net=host -e TARGET_HOST=<host> -e TARGET_PORT=<port> -e TARGET_ANGULARHOST=<angular-host> -e TARGET_ANGULARPORT=<angular-port> appdynamics/ecommerce-load$VERSION` where TARGET_HOST (default='lbr'), TARGET_PORT (default=80), TARGET_ANGULARHOST (default='angular') and TARGET_ANGULARPORT (default=8080) identify the remote ECommerce host:port.  The `--net=host` flag ensures that the container uses the host's networking, so that geo-resolution will work.

The following values can be set via docker environment variables:

1. `NUM_OF_USERS` (default: 5)
2. `RAMP_TIME` (default: 5)
3. `TIME_BETWEEN_RUNS` (default: 5000)
4. `TARGET_HOST` (default: lbr)
5. `TARGET_ANGULARHOST` (default: angular)
6. `TARGET_PORT` (default: 80)
7. `TARGET_ANGULARPORT` (default: 8080)
8. `WAIT_TIME` (default: 1000)

For more details of how to run the ECommerce demo containers, see [ecommerce-tomcat](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-Tomcat/Dockerhub.md).
