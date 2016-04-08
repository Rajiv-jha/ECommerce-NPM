ECommerce-Docker
================
Dockerfiles and configuration scripts for the ECommerce demo. 

Building the Container Images
-----------------------------
To build the containers, you need to supply paths to the AppDynamics agent installers used by the demo containers.  Download the latest versions directly from the [AppDynamics download site](https://download.appdynamics.com)

Two build scripts are available:

1. Full Build (`full-build.sh`): this will download all source code, build tools and OS package dependencies directly into the containers, and will run the gradle/maven builds as part of the container Dockerfile.  This is the easiest way to build the containers, but will involve substantial network download volumes.
2. Local Build (`build.sh`): this uses locally-built jar/war files, plus pre-downloaded Apache Tomcat and Oracle JDK distributions, to save network download times. This will result in much faster build times, but requires you to do some additional setup on your local build machine (see below)

The database containers (`ecommerce-oracle` and `ecommerce-mysql`) do not include AppDynamics agents and only need to be rebuilt if you want to refresh the database or OS version. You will need to download the Linux x64 RPM package installer for Oracle Database XE 11g R2 from the [Oracle Download Site](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads). To build the database containers, cd to the relevant build directories and run:

- ECommerce-Oracle `docker build -t appdynamics/ecommerce-oracle .`
- ECommerce-MySQL `docker build -t appdynamics/ecommerce-mysql .`

### Running a Full Build

1. Run `full-build.sh` without commandline args to be prompted (with autocomplete) for the agent installer paths __or__
2. Run `full-build.sh` with commandline args to supply agent installer paths

*Note: Run `full-build.sh --help` for a list of commandline arguments*

Run full-build.sh with the `-p` flag to prepare the build environment but skip the actual docker container builds.  This will build the Dockerfiles and add the AppDynamics agents to the build dirs: the containers can then be built manually with `docker build -t <container-name> .`.  Use this option to save time when making updates to only one container.

### Running a Local Build

1. Download the desired Apache Tomcat (.tar.gz) distribution from the [Apache Tomcat download site]()
2. Download the Oracle JDK (Linux x64 .rpm) distribution
3. Download and build the ECommerce source code projects (see below) 
4. Run `build.sh` without commandline args to be prompted (with autocomplete) for the agent installer paths __or__
5. Run `build.sh` with commandline args to supply agent installer paths, source code project locations and Tomcat/JDK distributions

*Note: Run `build.sh --help` for a list of commandline arguments*

### Building the ECommerce Source Projects

Clone the GitHub source code projects and build as follows:

1. [ECommerce-Java](https://github.com/Appdynamics/ECommerce-Java): `gradle war uberjar`
2. [ECommerce-Load](https://github.com/Appdynamics/ECommerce-Load): `gradle distZip`
3. [ECommerce-Angular](https://github.com/Appdynamics/ECommerce-Angular): `mvn clean install`
4. [docker-dbwrapper](https://github.com/Appdynamics/docker-dbwrapper): `gradle clean build`


Running the ECommerce Demo
--------------------------
### Using the run script

To run the demo:
`./run.sh <tag> <app_name>` where 

- `<tag>` is the docker tag for the container version to run 
- `<app_name>` is the name to register for the application

Note: The run.sh script will get AWS credentials (optional), controller host/port and analytics/events-service configuration from the following environment variables, which will be injected into the running containers:

- `AWS_ACCESS_KEY (optional - used for FulfillmentClient container)`
- `AWS_SECRET_KEY (optional - used for FulfillmentClient container)`
- `CONTR_HOST (do not include "http(s)://")`
- `CONTR_PORT`
- `ACCOUNT_NAME (Global ACcount Name from Controller License screen)`
- `ACCESS_KEY (Access Key from Controller License screen)`
- `EVENT_ENDPOINT (include "http(s)://" and port)`  

### Manual Injection of the EUM App Key

Once the containers have been started, use the `update-rum-key` command to configure manual injection of the EUM App Key by the LBR container:

`docker exec -it lbr update-rum-key -k <EUM APP Key>`

Other commandline options are available to override the default values for `beaconUrlHttp` and `adrumExtUrl` in the Browser RUM Javascript Agent. In most cases, you will want to download the Javascript directly from the Controller's EUM Configuration page, in which case these values will be pre-configured.  For more details, run:

`docker exec -it lbr update-rum-key`

### Starting the Machine Agents or Analytics Agents

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
