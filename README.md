# Communication Server

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Structure](#structure)
- [Contributing](#contributing)

## About <a name = "about"></a>

Cluster of servers used for XMPP communication. 
The Communication Server is a part of the [Agents Assembly](https://agents-assembly.com) ecosystem.
Other applications are:
- [Local Interface](https://github.com/agent-based-information-flow-simulation/local-interface) - GUI for simulation definition, management, and analysis.
- [Simulation Run Environment](https://github.com/agent-based-information-flow-simulation/simulation-run-environment) - environment for running scalable agent-based simulations.
- [Agents Assembly Translator](https://github.com/agent-based-information-flow-simulation/agents-assembly-translator) - translator for Agents Assembly code.
- [Local Development Environment](https://github.com/agent-based-information-flow-simulation/local-development-environment) - simple environment for running agent-based simulations.

## Getting Started <a name = "getting_started"></a>

### Prerequisites

```
docker
docker-compose (dev only)
```

### Installing
To use the application, utilize the `server.sh` script. </br>
First, initialize the cluster:
```
./server.sh init
```

Alternatively, join the existing cluster using the `TOKEN` received from the `init` command:
```
./server.sh join TOKEN
```

Then, create the required networks (this step needs to be done only once inside the cluster):
```
./server.sh network
```

Finally, start the application:
```
./server.sh start
```

To see all the available options run the `help` command:
```
./server.sh help
```

## Usage <a name = "usage"></a>
The application must be used with a dedicated user interface and simulation run environment.

## Structure <a name = "structure"></a>
The structure of the communication server is presented below.
- [DB](#db)
- [DB GUI](#db-gui)
- [Entrypoint](#entrypoint)
- [Tsung benchmark](#tsung-benchmark)
- [XMPP server](#xmpp-server)

### DB <a name = "db"></a>
The service is used to store data needed by the servers.
It keeps registered agent data and cluster-related information.

Environment variables:
* `POSTGRES_DB` - database name (i.e., postgres)
* `POSTGRES_USER` - superuser name (i.e., postgres)
* `POSTGRES_PASSWORD` - superuser password (i.e., postgres)

Host port mapping (dev only):
* port `5432`

### DB GUI (dev only) <a name = "db-gui"></a>

Environment variables:
* `PGADMIN_DEFAULT_EMAIL` - admin email address (i.e., admin@admin.org)
* `PGADMIN_DEFAULT_PASSWORD` - admin password (i.e., admin)
* `PGADMIN_CONFIG_SERVER_MODE` - set server mode (i.e., False)

Host port mapping (dev only):
* port `5433`

### Entrypoint <a name = "entrypoint"></a>
The service is the entrypoint to the cluster of XMPP servers.
It is implemented using Haproxy to provide the load balancing functionality.
So, the server with the least amount of connections receives the incoming connection.
Additionally, it uses the Dataplane API included in the Haproxy distribution to enable the configuration on the runtime without the need to reload the service.

[Docker Hub](https://hub.docker.com/r/madpeh/cs-entrypoint)

Environment variables:
* `ADMIN_PANEL_LISTEN_PORT` - XMPP server admin panel listen port (i.e., 8080)
* `API_PORT` - [Data Plane API](https://www.haproxy.com/documentation/hapee/latest/api/data-plane-api/) listen port (i.e., 5555)
* `XMPP_LISTEN_PORT` - XMPP server listen port (i.e., 5222)

Host port mapping (dev only):
* port `5555`

### Tsung benchmark <a name = "tsung-benchmark"></a>
The service is a benchmark utility to test the cluster of servers under load.

[Docker Hub](https://hub.docker.com/r/madpeh/cs-tsung-benchmark)

Host port mapping (dev only):
* port `8081`

### XMPP server <a name = "tsung-benchmark"></a>
The servers are instances of Tigase.
To increase performance, they are configured to provide the minimum required functionalities.
The first one is to register agents in the database, and the second one is to exchange the messages sent between the agents. The servers are set to operate in cluster mode.
After starting, each instance communicates with the proxy service via its API to create a new entry about the server in the proxy configuration file.

[Docker Hub](https://hub.docker.com/r/madpeh/cs-xmpp-server)

Environment variables:
* `ADMIN_JID` - administrator JID (i.e., admin@cs_entrypoint)
* `ADMIN_PASSWORD` - administrator password (i.e., admin)
* `DB_HOST` - database address (i.e., db)
* `DB_NAME` - database name with agent metadata (i.e., tigasedb)
* `DB_TYPE` - database type (i.e., postgresql)
* `DB_USER_NAME` - database owner name (i.e., admin)
* `DB_USER_PASSWORD` - database owner password (i.e., admin)
* `DB_POOL_SIZE` - XMPP server DB connection pool size (i.e., 20)
* `DB_ROOT_USER_NAME` - database superuser name (i.e., postgres); it must match the DB `POSTGRES_USER` value
* `DB_ROOT_USER_PASSWORD` - database superuser password (i.e., postgres); it must match the DB `POSTGRES_PASSWORD` value
* `DEFAULT_VIRTUAL_HOST` - default virtual host name in Tigase (i.e., cs_entrypoint)
* `ENTRYPOINT_REGISTRATION_ADDRESS` - entrypoint registration address (i.e., entrypoint:5555)
* `ENTRYPOINT_REGISTRATION_BACKEND_ADMIN_PANEL_NAME` - entrypoint backend name for admin panel (i.e., admin_panel)
* `ENTRYPOINT_REGISTRATION_BACKEND_ADMIN_PANEL_PORT` - entrypoint admin panel backend listen port (i.e., 8080)
* `ENTRYPOINT_REGISTRATION_BACKEND_XMPP_NAME` - entrypoint backend name for XMPP (i.e., xmpp)
* `ENTRYPOINT_REGISTRATION_BACKEND_XMPP_PORT` - entrypoint XMPP backend listen port (i.e., 5222)
* `ENTRYPOINT_REGISTRATION_MAX_RETRIES` - maximum number of retries of registartion in entrypoint (i.e., 100)
* `ENTRYPOINT_REGISTRATION_USER_NAME` - entrypoint API user name (i.e., admin)
* `ENTRYPOINT_REGISTRATION_USER_PASSWORD` - entrypoint API user password (i.e., admin)
* `WAIT_FOR_DB_ADDRESS` - DB address (i.e., db:5432)
* `WAIT_FOR_ENTRYPOINT_ADDRESS` - entrypoint address (i.e., entrypoint:5555)

Host port mapping (dev only):
* port `5222` (XMPP via entrypoint)
* port `8080` (admin panel via entrypoint)

## Contributing <a name = "contributing"></a>
Please follow the [contributing guide](CONTRIBUTING.md) if you wish to contribute to the project.
