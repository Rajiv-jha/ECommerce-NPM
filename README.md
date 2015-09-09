ECommerce-Docker
================
Dockerfiles and configuration scripts for the ECommerce demo. 

Building the Container Images
-----------------------------
To build the containers, you need to supply paths to the AppDynamics agent installers used by the demo containers.  
Download the latest versions directly from the [AppDynamics download site](https://download.appdynamics.com)

1. Run `build.sh` without commandline args to be prompted (with autocomplete) for the agent installer paths __or__
2. Run `build.sh -a <App Server Agent> -m <Machine Agent> -d <Database Agent> -w <Web Server Agent> -r <Javascript Agent> [-y <Analytics Agent>] [-j <Oracle JDK7>]` to supply agent installer paths 

Note: Run build.sh with the `-p` flag to prepare the build environment but skip the actual docker container builds.  This will build the Dockerfiles and add the AppDynamics agents to the build dirs: the containers can then be built manually with `docker build -t <container-name> .`.  Use this option to save time when making updates to only one container.

The database containers (`ecommerce-oracle` and `ecommerce-mysql`) do not include AppDynamics agents and only need to be rebuilt if you want to refresh the database or OS version. You will need to download the Linux x64 RPM package installer for Oracle Database XE 11g R2 from the [Oracle Download Site](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads). To build the database containers, cd to the relevant build directories and run:

- ECommerce-Oracle `docker build -t appdynamics/ecommerce-oracle .`
- ECommerce-MySQL `docker build -t appdynamics/ecommerce-mysql .`

Running the ECommerce Demo
--------------------------
To run the demo:
`./run.sh <tag> <app_name>` where 

- `<tag>` is the docker tag for the container version to run 
- `<app_name>` is the name to register for the application

Note: The run.sh script will get AWS credentails (optional), controller host/port and analytics/events-service configuration from the following environment variables, which will be injected into the running containers:

- `AWS_ACCESS_KEY (optional - used for FulfillmentClient container)`
- `AWS_SECRET_KEY (optional - used for FulfillmentClient container)`
- `CONTR_HOST`
- `CONTR_PORT`
- `ACCOUNT_NAME`
- `ACCESS_KEY`
- `EVENT_ENDPOINT`  

Starting the Machine Agent and Analytics Agent
----------------------------------------------
By default, on startup the containers will run the App Server / Database / Web Server Agents only.
The Machine Agent or standalone Analytics Agent can be started using `docker exec` once the container is running:

1. To start the Machine Agents (with integrated analytics-agent): `./startMachineAgents.sh`
2. To start the Standalone Analytics Agents (ecommerce-tomcat only): `./startAnalyticsAgents.sh`

Tagging and Pushing to DockerHub
--------------------------------
Use the following utilities to manage container tags and push to DockerHhub

- `./tagAll.sh <tag>`
- `./untagAll.sh <tag>`
- `./pushAll.sh <tag>`
