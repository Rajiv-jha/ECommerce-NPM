Provides an Apache httpd-based rev proxy for the ECommerce demo to allow remote load-gen containers to connect (e.g. from different AWS regions). The proxy will forward requests to the `lbr` container, with should be linked using `--link lbr:lbr`  

* `docker run --rm -it --name proxy --link lbr:lbr appdynamics/ecommerce-proxy`
* `docker run -d --name proxy --link lbr:lbr appdynamics/ecommerce-proxy`

See [ecommerce-load](https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-Load) for what to run on the remote.
