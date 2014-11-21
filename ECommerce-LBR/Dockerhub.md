Provides an Apache httpd-based AJP load balancer for the ECommerce demo.  This will load balance across two instance of the ECommerce-Server tier.  

The configuration assumes that two ECommerce-Server instances are running with `--name web` and `--name web1` respectively, e.g.

* `docker run --rm -it --name web -e web=true -p 8080:8080 --link controller:controller --link db:db --link ws:ws --link jms:jms appdynamics/ecommerce-tomcat`
* `docker run --rm -it --name web1 -e web=true -p 8081:8080 --link controller:controller --link db:db --link ws:ws --link jms:jms appdynamics/ecommerce-tomcat`

See the [httpd configuration file](https://github.com/Appdynamics/ECommerce-Docker/blob/master/ECommerce-LBR/ajp_proxy.conf) for details.
