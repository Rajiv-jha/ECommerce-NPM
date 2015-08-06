ECommerce-Docker
================
Dockerfiles and configuration scripts for the ECommerce demo. 

Building the Container Images
-----------------------------
To build the containers, you need to supply paths to the AppDynamics agent installers used by the demo containers.  
Download the latest versions directly from the [AppDynamics download site](https://download.appdynamics.com)

1. Run `build.sh` without commandline args to be prompted (with autocomplete) for the agent installer paths __or__
2. Run `build.sh -a <App Server Agent> -m <Machine Agent> -d <Database Agent> -w <Web Server Agent> -r <Javascript Agent> [-y <Analytics Agent>] [-j <Oracle JDK7>]` to supply agent installer paths 

Note: Run build.sh with the `-p` flag to prepare the build environment but skip the actual docker container builds.  This will build the Dockerfiles and add the AppDyanmics agents to the build dirs: the containers can then be built manually with `docker build -t <container-name> .`.  Use this option to save time when making updates to only one container.

Running the ECommerce Demo
--------------------------
To run the demo:
`./run.sh <tag> <app_name>` where 

- `<tag>` is the docker tag for the container version to run 
- `<app_name>` is the name to register for the application

Note: The run.sh script will get controller host/port and analytics/events-service configuration from env.sh in the root of this project.  These values will be injected into the running containers via environment variables.  

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
