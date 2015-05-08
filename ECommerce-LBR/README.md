Provides an Apache httpd-based AJP load balancer for the ECommerce demo, with mod_appdynamics installed.  This will load balance across two instance of the ECommerce-Server tier.  

`docker run --name=lbr -h lbr -e APP_NAME=ECommerce -e CONTROLLER=controller -e APPD_PORT=8090 -e TIER_NAME=ECommerce_WebTier -e NODE_NAME=ECommerce_Apache --link web:web --link web1:web1 -p 80:80 -d appdynamics/ecommerce-apache`

The following environment variables are set with the docker -e flag:

1. `CONTROLLER`
2. `APPD_PORT`
3. `APP_NAME`
4. `TIER_NAME`
5. `NODE_NAME`

The configuration assumes that two ECommerce-Server instances are running with `--name web` and `--name web1` respectively, e.g.

* `docker run --rm -it --name web -e web=true -p 8080:8080 --link controller:controller --link db:db --link ws:ws --link jms:jms appdynamics/ecommerce-tomcat`
* `docker run --rm -it --name web1 -e web=true -p 8081:8080 --link controller:controller --link db:db --link ws:ws --link jms:jms appdynamics/ecommerce-tomcat`

See the [httpd configuration file](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-Apache/ajp_proxy.conf) for details.

To view the AppDynamics Native SDK Proxy log: `docker exec -it lbr tail-proxy-log`

To view the Apache access log: `docker exec -it lbr tail-access-log`

To view the Apache error log: `docker exec -it lbr tail-error-log`
