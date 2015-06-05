ECommerce-Docker
================
Dockerfiles and configuration scripts for the ECommerce demo. 

Building the Container Images
-----------------------------
To build the containers, you need to supply paths to the App Server, Machine and DB Agent installers to use,
or download the latest versions directly from the [AppDynamics download site](https://download.appdynamics.com)

1. Run `build.sh` without commandline args to be prompted (with autocomplete) for the agent installer paths __or__
2. Run `build.sh -a <App Server Agent> -m <Machine Agent> -d <Database Agent> -w <Web Server Agent> [-y <Analytics Agent>] [-j <Oracle JDK7>]` to supply agent installer paths 

Running the ECommerce Demo
--------------------------
To run the demo:
`./run.sh <tag> <app_name>` where 

- `<tag>` is the docker tag for the container version to run 
- `<app_name>` is the name to register for the application

Starting the Machine Agent and Analytics Agent
----------------------------------------------
By default, on startup the containers will run the App Server / Database / Web Server Agents only.
The Machine Agent or standalone Analytics Agent can be started using `docker exec` once the container is running:

1. To start the Machine Agents (with integrated analytics-agent): `./startMachineAgents.sh [zip | rpm]`
2. To start the Standalone Analytics Agents (ecommerce-tomcat only): `./startAnalyticsAgent.sh`

Tagging and Pushing to DockerHub
--------------------------------
Use the following utilities to manage container tags and push to DockerHhub

- `./tagAll.sh <tag>`
- `./untagAll.sh <tag>`
- `./pushAll.sh <tag>`
