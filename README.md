ECommerce-Docker
================
Dockerfiles and configuration scripts for the ECommerce demo. 
These are used to build Docker images for all components of the ECommerce demo:

1. [ecommerce-java](https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-Java)
2. [ecommerce-tomcat](https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-Tomcat)
3. [ecommerce-activemq](https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-ActiveMQ)
4. [ecommerce-dbagent](https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-DBAgent)
5. [ecommerce-lbr](https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-LBR)
6. [ecommerce-load](https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-Load)
7. [ecommerce-synapse](https://github.com/Appdynamics/ECommerce-Docker/tree/master/ECommerce-Synapse)

Building the Container Images
-----------------------------
To build the containers, you need to supply paths to the App Server, Machine and DB Agent installers to use,
or download the latest versions directly from the [AppDynamics download site](https://download.appdynamics.com)

1. Run `build.sh` without commandline args to be prompted (with autocomplete) for the agent installer paths __or__
2. Run `build.sh -a <Path to App Server Agent> -m <Path to Machine Agent> -d <Path to Database Agent>` to supply agent installer paths __or__
3. Run `build.sh --download` to download from the [AppDynamics download site](https://download.appdynamics.com) (portal login required)

